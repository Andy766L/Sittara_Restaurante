import { useState } from 'react';
import { ArrowLeft, Calendar as CalendarIcon, Clock, Users, Check } from 'lucide-react';
import { Restaurant } from '../../types';
import { Button } from '../ui/button';
import { Calendar } from '../ui/calendar';

interface CreateReservationScreenProps {
  restaurant: Restaurant;
  onBack: () => void;
  onConfirm: () => void;
}

export function CreateReservationScreen({ restaurant, onBack, onConfirm }: CreateReservationScreenProps) {
  const [date, setDate] = useState<Date | undefined>(new Date());
  const [time, setTime] = useState('20:00');
  const [guests, setGuests] = useState(2);
  const [showSuccess, setShowSuccess] = useState(false);

  const times = [
    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30',
    '19:00', '19:30', '20:00', '20:30', '21:00', '21:30', '22:00'
  ];

  const handleConfirm = () => {
    setShowSuccess(true);
    setTimeout(() => {
      onConfirm();
    }, 2000);
  };

  if (showSuccess) {
    return (
      <div className="h-full bg-white flex flex-col items-center justify-center p-6">
        <div className="bg-green-100 rounded-full p-8 mb-6 animate-bounce">
          <Check className="w-16 h-16 text-green-600" />
        </div>
        <h1 className="mb-4 text-center">¡Reserva confirmada!</h1>
        <p className="text-center text-gray-600">
          Tu mesa en {restaurant.name} ha sido reservada exitosamente
        </p>
      </div>
    );
  }

  return (
    <div className="h-full bg-white flex flex-col">
      <div className="flex items-center gap-4 p-4 border-b">
        <button onClick={onBack} className="p-2 hover:bg-gray-100 rounded-full">
          <ArrowLeft className="w-6 h-6" />
        </button>
        <h2>Reservar mesa</h2>
      </div>

      <div className="flex-1 overflow-auto pb-6">
        <div className="p-4">
          <div className="bg-gray-50 rounded-2xl p-4 mb-6">
            <h3 className="mb-1">{restaurant.name}</h3>
            <p className="text-sm text-gray-600">{restaurant.address}</p>
          </div>

          <div className="mb-6">
            <div className="flex items-center gap-2 mb-3">
              <CalendarIcon className="w-5 h-5 text-[#4C7BF3]" />
              <h3>Selecciona una fecha</h3>
            </div>
            <div className="bg-gray-50 rounded-2xl p-4">
              <Calendar
                mode="single"
                selected={date}
                onSelect={setDate}
                className="w-full"
                disabled={(date) => date < new Date()}
              />
            </div>
          </div>

          <div className="mb-6">
            <div className="flex items-center gap-2 mb-3">
              <Clock className="w-5 h-5 text-[#4C7BF3]" />
              <h3>Selecciona una hora</h3>
            </div>
            <div className="grid grid-cols-4 gap-2">
              {times.map((t) => (
                <button
                  key={t}
                  onClick={() => setTime(t)}
                  className={`py-3 rounded-xl transition-colors ${
                    time === t
                      ? 'bg-[#4C7BF3] text-white'
                      : 'bg-gray-50 text-gray-700 hover:bg-gray-100'
                  }`}
                >
                  {t}
                </button>
              ))}
            </div>
          </div>

          <div className="mb-6">
            <div className="flex items-center gap-2 mb-3">
              <Users className="w-5 h-5 text-[#4C7BF3]" />
              <h3>Número de personas</h3>
            </div>
            <div className="flex items-center gap-4 bg-gray-50 rounded-2xl p-4">
              <button
                onClick={() => setGuests(Math.max(1, guests - 1))}
                className="w-12 h-12 bg-white rounded-full flex items-center justify-center hover:bg-gray-100 transition-colors"
              >
                -
              </button>
              <span className="flex-1 text-center">{guests}</span>
              <button
                onClick={() => setGuests(Math.min(20, guests + 1))}
                className="w-12 h-12 bg-white rounded-full flex items-center justify-center hover:bg-gray-100 transition-colors"
              >
                +
              </button>
            </div>
          </div>

          <Button
            onClick={handleConfirm}
            className="w-full h-12 bg-[#4C7BF3] hover:bg-[#3a5fc7] text-white rounded-2xl"
          >
            Confirmar reserva
          </Button>
        </div>
      </div>
    </div>
  );
}
