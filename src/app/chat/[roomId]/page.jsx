'use client'

import { FontAwesomeIcon } from "@fortawesome/react-fontawesome"
import { faPaperPlane } from '@fortawesome/free-solid-svg-icons'
import { useEffect, useRef, useState } from "react"
import TextareaAutosize from 'react-textarea-autosize'
import moment from "moment";
import Image from "next/image"
import { useRoomProvider } from "@/context/roomProvider"
import { useChatProvider } from "@/context/chatProvider"

export default function Page() {
    const inputFocus = useRef(null)
    const isAndroid = typeof navigator !== "undefined" && /android/i.test(navigator.userAgent);

    const [hidden, setHidden] = useState(true)

    const scrollRef = useRef(null)
    const { inputChat, setInputChat, fetchMemberRoom, realtimeChat, messages, sendMessage, leaveChat } = useChatProvider()
    const { memberAllias, onlineUsers, memberRoomId } = useRoomProvider()

    useEffect(() => {
        const fetchAllData = async () => {
            await fetchMemberRoom()
            realtimeChat()
        }
        fetchAllData()
        inputFocus.current.focus()
    }, [])

    const handleChangeText = (e) => {
        setInputChat(e.target.value)
    }

    const handleEnterSend = async (e) => {
        try {
            if (!isAndroid && e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                await sendMessage('send');
            }
        } catch (err) {
            if (process.env.NODE.env === 'development')
                console.error("function Error:", err);
        }

    }

    useEffect(() => {
        scrollRef.current?.scrollIntoView({ behavior: "smooth" });
    }, [messages]);

    return (
        <div className="relative w-screen h-screen">
            <div className={`${hidden ? "hidden" : "block"} absolute top-1/2 left-1/2 border-2 py-16 px-24 -translate-x-1/2 -translate-y-1/2 bg-black rounded z-50`}>
                <h1 className="text-center font-semibold text-xl mb-10">Leave?</h1>
                <div className="flex gap-8">
                    <button onClick={() => leaveChat()} className="bg-red-600 rounded px-8 py-2 flex-1/2 cursor-pointer hover:scale-105 hover:brightness-105">Yes</button>
                    <button onClick={() => setHidden(true)} className="bg-green-600 rounded px-8 py-2 flex-1/2 cursor-pointer hover:scale-105 hover:brightness-105">No</button>
                </div>
            </div>
            <div className="lg:px-96 h-full flex flex-col">
                <div className="flex justify-between border-[#BCDDFC] border-2 px-2">
                    <ul className="py-3 h-full w-32 relative">
                        {memberAllias?.map((member, index) => {
                            const isOnline = onlineUsers.includes(member.user_id)
                            return (
                                <div key={index} style={{ left: `${index * 24}px` }} className={`transform duration-500 absolute h-12 w-12 rounded-full bg-slate-500 border-3 flex items-center justify-center object-cover overflow-hidden ${isOnline ? "border-green-500" : "border-red-500 brightness-75"} hover:scale-110 `}>
                                    <Image alt="profile" src={`/profile/${member.allias.slice(0, -3)}.png`} fill={true} sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw" />
                                </div>
                            )
                        })}
                    </ul>
                    <button onClick={() => setHidden(false)} className="hover:scale-105 transform duration-300 hover:brightness-110 bg-red-600 p-2 rounded my-4 cursor-pointer">Leave Chat</button>
                </div>
                <div className="p-4 flex flex-col grow border-x-2 border-[#BCDDFC] overflow-y-auto container-snap">
                    {
                        messages.map((chat) => {
                            if (chat.event !== 'send') {
                                return (
                                    <p key={chat.id} className="text-center text-gray-400 italic text-sm my-2">
                                        {chat.messages}
                                    </p>
                                )
                            }
                            const member = memberAllias.find((allias) => allias.id === chat.member_room_id)
                            if (!member) return (<div key={chat.id}></div>)
                            const thisUser = member.id === memberRoomId
                            let time = moment.utc(chat.created_at).local().format("HH:mm")
                            return (<div key={chat.id} className={`flex gap-2 ${thisUser ? "self-end flex-row-reverse " : "self-start flex-row"} mb-4`}>
                                <div className="w-8 h-8 lg:h-12 lg:w-12 rounded-full aspect-square object-cover overflow-hidden bg-red-500 relative shrink-0">
                                    <Image alt="profile" src={`/profile/${member.allias.slice(0, -3)}.png`} fill={true} sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw" />
                                </div>
                                <div className="break-all shrink">
                                    <div className={`relative ${thisUser ? "rounded-l-3xl rounded-br-3xl bg-[#BCDDFC] text-black" : "rounded-r-3xl rounded-bl-3xl bg-slate-800 text-white text-end"} whitespace-pre-line px-4 py-2 flex flex-col`}>
                                        <h4 className={`lg:font-bold font-semibold mb-0.5 text-base lg:text-lg ${thisUser ? "text-end" : "text-start"}`}>{member?.allias}</h4>
                                        <p className={`text-base lg:text-xl text-start`}>{chat.messages} <span className="lg:text-sm text-xs ml-2 float-right relative top-2">{time}</span></p>
                                    </div>
                                </div>
                            </div>)
                        }
                        )
                    }
                    <div ref={scrollRef}></div>
                </div>
                <div className="border-x-2 border-[##BCDDFC] p-2 flex gap-2">
                    <div className="rounded-4xl flex-grow bg-slate-800 p-2 flex border-transparent border-2">
                        <TextareaAutosize ref={inputFocus} maxRows={4} value={inputChat} enterKeyHint="enter" onChange={handleChangeText} onKeyDown={handleEnterSend} type="text" placeholder="Type a message" className="p-2 outline-none w-full overflow-auto container-snap" />
                    </div>
                    <button onClick={() => sendMessage('send')} className="cursor-pointer self-end bg-[#BCDDFC] p-2 aspect-square grow-0 h-16 text-black rounded-full"><FontAwesomeIcon size="xl" icon={faPaperPlane} /></button>
                </div>
            </div>
        </div>
    )
}