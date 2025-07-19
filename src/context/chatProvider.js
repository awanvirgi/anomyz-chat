'use client'

import { DeleteSingleColumnTable, selectFilterRowTable, supabase } from "@/api/api"
import { v4 as uuidv4 } from "uuid"
import { useRoomProvider } from "./roomProvider"

const { createContext, useState, useContext, useEffect, useRef } = require("react")

const ChatContext = createContext(undefined)

let chatChannel = null

const ChatProvider = ({ children }) => {
    const lastActionRef = useRef(null);

    const { memberRoomId, roomId, userId, nama, stateMember, setMemberAllias, router, channelState, setChannelState } = useRoomProvider()

    const [messages, setMessages] = useState([])
    const [inputChat, setInputChat] = useState("")
    const [onlineUsers, setOnlineUsers] = useState([])
    const [isConnect, setIsConnect] = useState(false)
    const [hydratedChat, setHydratedChat] = useState(false)

    const UUID_REGEX =
        /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
    function isValidUuid(v) {
        return typeof v === 'string' && UUID_REGEX.test(v);
    }

    const isDev = process.env.NODE_ENV === 'development';
    function logError(...args) {
        if (isDev) {
            console.error(...args);
        }
    }

    function realtimeChat() {
        if (chatChannel) return
        chatChannel = supabase.channel(`room_chat${roomId}`)

        chatChannel.on('broadcast',
            {
                event: 'message',
            },
            (payload) => {
                setMessages((current) => [...current, payload.payload])
            }
        )
            .subscribe(async (status) => {
                if (status === 'SUBSCRIBED') {
                    setIsConnect(true)
                }
            })

        return () => {
            supabase.removeChannel(chatChannel)
        }
    }

    async function sendMessage(event = 'send') {
        if (event === 'send' && !inputChat.trim()) return;
        if (!chatChannel || !isConnect) return;

        let eventText = "";

        if (event === 'send') {
            eventText = inputChat;
        } else {
            eventText = `${stateMember?.data?.[0]?.allias} has ${event}`;
        }

        const chat = {
            id: uuidv4(),
            event,
            messages: eventText,
            member_room_id: memberRoomId,
            user: {
                allias: nama
            },
            created_at: new Date().toISOString()
        };

        setMessages((current) => [...current, chat]);
        await chatChannel.send({
            type: 'broadcast',
            event: 'message',
            payload: chat
        });

        if (event === 'send') {
            setInputChat("");
        }
    }

    async function leaveChat() {
        try {
            let cekMember = await selectFilterRowTable('member_room', '*', 'room_id', roomId)
            if (cekMember.length <= 1) {
                await DeleteSingleColumnTable('room', 'room_id', roomId)
            } else {
                await DeleteSingleColumnTable('member_room', 'id', memberRoomId)
            }

            if (chatChannel || channelState) supabase.removeAllChannels()
            chatChannel = null;
            setChannelState(null)
            await supabase.auth.signOut({ scope: 'local' })
            await supabase.functions.invoke('user-self-deletion', {
                body: {
                    user_id: userId
                }
            })
            localStorage.removeItem('memberRoomId')
            localStorage.removeItem('roomId')
            localStorage.removeItem('userAllias')
            localStorage.removeItem('userId')
            setMessages([])
            router.push("/")
        } catch (err) {
            logError("Function Error : ", err)
        }
    }

    async function fetchMemberRoom() {
        try {
            const dataMember = await selectFilterRowTable('member_room', 'id,allias,user_id', 'room_id', roomId)
            setMemberAllias(dataMember)
        } catch (err) {
            logError('Function Error : ', err)
        }
    }

    const processedEvents = useRef(new Set());

    useEffect(() => {
        if (!stateMember?.event || !stateMember?.data?.[0]?.user_id) return;
        if (!isValidUuid(roomId)) return;

        const userIdEvent = stateMember.data[0].user_id;
        const action = stateMember.event === "join" ? "joined" : "left";
        const actionKey = `${userIdEvent}_${stateMember.event}`;

        // Jika event ini sudah pernah diproses, skip
        if (processedEvents.current.has(actionKey)) return;
        processedEvents.current.add(actionKey);

        sendMessage(action);
        fetchMemberRoom();
    }, [stateMember, roomId]);




    useEffect(() => {
        setHydratedChat(true);
    }, []);

    useEffect(() => {
        if (!hydratedChat || !roomId || !userId) return;
        if (!chatChannel || chatChannel.subscriptionStatus !== "subscribed") {
            realtimeChat()
        }
    }, [hydratedChat, roomId, userId]);

    if (!hydratedChat) return null

    return (
        <ChatContext.Provider value={{ messages, setMessages, inputChat, setInputChat, onlineUsers, setOnlineUsers, sendMessage, fetchMemberRoom, realtimeChat, leaveChat }}>
            {children}
        </ChatContext.Provider>
    )
}
export default ChatProvider
export function useChatProvider() {
    return useContext(ChatContext)
}