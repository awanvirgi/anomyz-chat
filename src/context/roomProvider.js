'use client'

import { InsertSingleTable, selectSingleFilterRowTable, createAccount, selectFilterRowTable, DeleteSingleColumnTable } from "@/api/api";
import { supabase } from "@/api/api";
import { useRouter } from "next/navigation";

const { createContext, useState, useContext, useEffect } = require("react")


const RoomContext = createContext(undefined)

let roomChannel = null

const RoomProvider = ({ children }) => {
    const router = useRouter()
    let animal = ["Tiger", "Monkey", "Penguin", "Cat", "Dog", "Wolf", "Bird", "Bear", "Rabbit", "Butterfly"]
    const [nama, setNama] = useState("")
    const [waitingId, setWaitingId] = useState("")
    const [roomType, setRoomType] = useState(2)
    const [loading, setLoading] = useState(false)
    const [memberAllias, setMemberAllias] = useState([])
    const [roomId, setRoomId] = useState("")
    const [userId, setUserId] = useState("")
    const [memberRoomId, setMemberRoomId] = useState("")
    const [onlineUsers, setOnlineUsers] = useState([]);
    const [channelState, setChannelState] = useState(null)
    const [stateMember, setStateMember] = useState({})

    const [hydratedRoom, setHydratedRoom] = useState(false)

    function nameGenerator() {
        const alias = animal.sort(() => 0.5 - Math.random())[0] + "'" + Math.floor(Math.random() * 90 + 10)
        localStorage.setItem("userAllias", alias)
        setNama(alias)
        return alias
    }

    const isDev = process.env.NODE_ENV === 'development';
    function logError(...args) {
        if (isDev) {
            console.error(...args);
        }
    }

    async function initAnonSession() {
        try {
            const { data: anonData, error: anonError } = await supabase.auth.getSession()
            if (anonData.session == null) {
                let { user } = await createAccount(nama)
                localStorage.setItem("userId", user.id)
                setUserId(user?.id)
            } else {
                localStorage.setItem("userId", anonData?.session.user.id)
                setUserId(anonData?.session.user.id)
            }
        } catch (err) {
            logError("function error : ", err)
        }
    }

    async function quickJoin() {
        try {
            if (roomType == 0) {
                return alert("Please select a chat room type first")
            }
            await initAnonSession()
            const waitRoom = await InsertSingleTable('waiting_list', { allias: nama, max: roomType })
            setWaitingId(waitRoom.id)
            setLoading(true)
        } catch (err) {
            logError("Function Error : ", err)
        }
    }

    async function cancelJoin() {
        try {
            await DeleteSingleColumnTable('waiting_list', 'id', waitingId)
            setLoading(false)
        } catch (err) {
            logError("Function Error : ", err)
        }
    }

    function presenceRoom() {
        if (roomChannel) return

        roomChannel = supabase.channel(`presence_room_${roomId}`, {
            config: {
                presence: {
                    key: userId
                }
            }
        })
        roomChannel
            .on('presence', { event: 'sync' }, () => {
                const state = roomChannel.presenceState();
                const online = Object.keys(state);
                setOnlineUsers(online);

            })
            .on('presence', { event: 'join' }, ({ key, newPresences }) => {
                setStateMember({
                    event: 'join',
                    data: newPresences
                })
            })
            .on('presence', { event: 'leave' }, ({ key, leftPresences }) => {
                setStateMember({
                    event: 'left',
                    data: leftPresences
                })
            })

        roomChannel.subscribe((status) => {
            if (status === 'SUBSCRIBED') {
                roomChannel.track({
                    allias: nama,
                    user_id: userId
                });
                setChannelState(roomChannel)
            }
        })
        return () => {
            supabase.removeChannel(roomChannel)
            roomChannel = null;
        }
    }

    useEffect(() => {
        const updatePresence = presenceRoom();
        return updatePresence;
    }, [roomId, userId]);

    function initialRemoveAllChannel() {
        supabase.removeAllChannels()
    }

    useEffect(() => {
        if (!loading) return
        const intervalId = setInterval(async () => {
            const memberRoom = await selectSingleFilterRowTable('member_room', 'id,room_id', 'user_id', userId)
            if (memberRoom?.room_id) {
                clearInterval(intervalId)
                setWaitingId("")
                setRoomId(memberRoom.room_id)
                setMemberRoomId(memberRoom.id)
                localStorage.setItem("roomId", memberRoom.room_id)
                localStorage.setItem("memberRoomId", memberRoom.id)
                const dataMember = await selectFilterRowTable('member_room', 'id,allias', 'room_id', memberRoom.room_id)
                setMemberAllias(dataMember)
                router.push(`/chat/${memberRoom.room_id}`)
                setLoading(false)
            }
        }, 5000)
        setHydratedRoom(true)
        return () => clearInterval(intervalId)
    }, [loading, userId])

    useEffect(() => {
        const stored = localStorage.getItem("userAllias")
        if (stored) {
            setNama(stored)
        } else {
            const generatedName = nameGenerator()
            localStorage.setItem("userAllias", generatedName)
            setNama(generatedName)
        }
        if (typeof window !== "undefined") {
            const storedRoomId = localStorage.getItem("roomId")
            const storedUserId = localStorage.getItem("userId")
            const storedMemberRoomId = localStorage.getItem("memberRoomId")

            if (storedRoomId) setRoomId(storedRoomId)
            if (storedUserId) setUserId(storedUserId)
            if (storedMemberRoomId) setMemberRoomId(storedMemberRoomId)
        }
        setHydratedRoom(true)
    }, []);

    if (!hydratedRoom) return null

    return (
        <RoomContext.Provider value={{
            router,
            nama,
            roomId,
            stateMember,
            roomType,
            setRoomType,
            memberAllias,
            setMemberAllias,
            channelState,
            setChannelState,
            loading,
            memberRoomId,
            userId,
            onlineUsers,
            setOnlineUsers,
            nameGenerator,
            quickJoin,
            cancelJoin,
            initialRemoveAllChannel
        }}>
            {children}
        </RoomContext.Provider>
    )
}

export default RoomProvider
export function useRoomProvider() {
    return useContext(RoomContext)
}