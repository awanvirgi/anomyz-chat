import { useEffect, useState } from "react";

const LoadingDots = () => {
    const dots = [".", "..", "..."];
    const [index, setIndex] = useState(0);

    useEffect(() => {
        const interval = setInterval(() => {
            setIndex(prev => (prev + 1) % dots.length);
        }, 1000); // update setiap 0.5 detik

        return () => clearInterval(interval); // bersihkan interval saat unmount
    }, []);

    return <span>{dots[index]}</span>;
};

export default LoadingDots;