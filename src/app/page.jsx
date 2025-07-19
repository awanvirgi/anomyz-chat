'use client'

import LoadingDots from "@/component/loadingDots"
import { useRoomProvider } from "@/context/roomProvider"

import { useEffect, useState } from "react"

export default function Home() {
    const { nama, roomType, setRoomType, loading, nameGenerator, quickJoin, cancelJoin, initialRemoveAllChannel } = useRoomProvider()
    const setValueRoomType = (e) => {
        setRoomType(e.target.value)
    }
    useEffect(() => {
        initialRemoveAllChannel()
    }, [])
    return (
        <div className="py-16 lg:p-20">
            {loading ? (
                <div className="z-100 top-0 left-0 absolute w-full h-full bg-black/90 flex justify-center items-center text-xl">
                    <div className="flex flex-col justify-center items-center">
                        <p className="ml-1 animate-pulse">Searching for a match<LoadingDots /></p>
                        <button onClick={cancelJoin} className="mt-5 bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700 hover:scale-105 transform duration-500 ">Cancel</button>
                    </div>
                </div>
            ) : (<div className="hidden"></div>)}
            <h1 className="text-center text-6xl font-bold mb-16">Anonymz</h1>
            <section className="flex justify-center">
                <div>
                    <div className="mb-4">
                        <h5 className="mb-2">Allias Name</h5>
                        <div className="flex gap-2">
                            <div className="w-40 bg-slate-950 border-slate-900 border-2 rounded px-4 block py-2">{nama}</div>
                            <button onClick={nameGenerator} type="button" className="bg-slate-950 border-slate-800 border-2 h-full py-2 px-4 hover:bg-slate-800 hover:border-slate-700 transition duration-200 hover:scale-105">Random</button>
                        </div>
                    </div>
                    <label htmlFor="chatRoomType">
                        <h5 className="mb-2">Chat Room Type : </h5>
                        <select value={roomType} onChange={setValueRoomType} name="chatRoomType" id="chatRoomType" className=" border-r-8 mb-4 border-transparent outline outline-slate-800 pr-8 pl-2 text-lg bg-slate-950 rounded px-4 block py-[9px]">
                            <option value={0} disabled>Choose a Room Type</option>
                            <option value={2}>2 Members</option>
                            <option value={5}>5 Members</option>
                            <option value={7} >7 Members</option>
                        </select>
                    </label>
                    <div className="flex justify-center">
                        <button onClick={() => quickJoin()} className="p-2 rounded font-medium bg-[#BCDDFC] text-black hover:scale-105 transform duration-200">Quick Join</button>
                    </div>
                </div>
            </section>
        </div>
    )
}
