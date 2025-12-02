import { Calendar, Clock, Users, ChevronRight } from 'lucide-react';
import { Reservation } from '../types';
import { ImageWithFallback } from './figma/ImageWithFallback';

interface ReservationCardProps {
  reservation: Reservation;
  onClick: () => void;
}

export function ReservationCard({ reservation, onClick }: ReservationCardProps) {
  const statusColors = {
    pending: 'bg-orange-100 text-orange-700',
    confirmed: 'bg-green-100 text-green-700',
    cancelled: 'bg-red-100 text-red-700'
  };

  const statusLabels = {
    pending: 'Pendiente',
    confirmed: 'Confirmada',
    cancelled: 'Cancelada'
  };

  return (
    <div 
      onClick={onClick}
      className="bg-white rounded-2xl overflow-hidden shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1 cursor-pointer border border-gray-200/50"
    >
      <div className="flex items-center">
        <div className="w-28 h-28 flex-shrink-0">
          <ImageWithFallback 
            src={reservation.restaurantImage} 
            alt={reservation.restaurantName}
            className="w-full h-full object-cover"
          />
        </div>
        <div className="flex-1 p-4">
          <div className="flex items-start justify-between mb-2">
            <h3 className="text-lg font-bold text-text">{reservation.restaurantName}</h3>
            <span className={`text-xs font-medium px-3 py-1 rounded-full ${statusColors[reservation.status]}`}>
              {statusLabels[reservation.status]}
            </span>
          </div>
          <div className="flex flex-col gap-1.5">
            <div className="flex items-center gap-2 text-sm text-text-secondary">
              <Calendar className="w-4 h-4" />
              <span>{new Date(reservation.date).toLocaleDateString('es-ES', { 
                day: 'numeric', 
                month: 'long', 
                year: 'numeric' 
              })}</span>
            </div>
            <div className="flex items-center gap-2 text-sm text-text-secondary">
              <Clock className="w-4 h-4" />
              <span>{reservation.time}</span>
              <Users className="w-4 h-4 ml-3" />
              <span>{reservation.guests} personas</span>
            </div>
          </div>
        </div>
        <div className="px-4">
          <ChevronRight className="w-6 h-6 text-gray-400" />
        </div>
      </div>
    </div>
  );
}
