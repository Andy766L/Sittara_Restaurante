import { useEffect } from 'react';
import { Utensils } from 'lucide-react';

interface SplashScreenProps {
  onComplete: () => void;
}

export function SplashScreen({ onComplete }: SplashScreenProps) {
  useEffect(() => {
    const timer = setTimeout(() => {
      onComplete();
    }, 2000);

    return () => clearTimeout(timer);
  }, [onComplete]);

  return (
    <div className="h-full bg-gradient-to-br from-[#4C7BF3] to-[#3a5fc7] flex flex-col items-center justify-center">
      <div className="animate-bounce">
        <div className="bg-white rounded-full p-8 shadow-2xl">
          <Utensils className="w-16 h-16 text-[#4C7BF3]" />
        </div>
      </div>
      <h1 className="mt-8 text-white">Sittara</h1>
      <p className="text-white/80 mt-2">Reserva tu mesa perfecta</p>
    </div>
  );
}
