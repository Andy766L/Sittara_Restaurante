import { Calendar, Clock, Users } from 'lucide-react';
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
      className="bg-white rounded-2xl overflow-hidden shadow-sm hover:shadow-md transition-shadow cursor-pointer"
    >
      <div className="flex">
        <div className="w-24 h-24 flex-shrink-0">
          <ImageWithFallback 
            src={reservation.restaurantImage} 
            alt={reservation.restaurantName}
            className="w-full h-full object-cover"
          />
        </div>
        <div className="flex-1 p-4">
          <div className="flex items-start justify-between mb-2">
            <h3 className="text-sm">{reservation.restaurantName}</h3>
            <span className={`text-xs px-2 py-1 rounded-full ${statusColors[reservation.status]}`}>
              {statusLabels[reservation.status]}
            </span>
          </div>
          <div className="flex flex-col gap-1">
            <div className="flex items-center gap-2 text-sm text-gray-600">
              <Calendar className="w-4 h-4" />
              <span>{new Date(reservation.date).toLocaleDateString('es-ES', { 
                day: 'numeric', 
                month: 'long', 
                year: 'numeric' 
              })}</span>
            </div>
            <div className="flex items-center gap-2 text-sm text-gray-600">
              <Clock className="w-4 h-4" />
              <span>{reservation.time}</span>
              <Users className="w-4 h-4 ml-2" />
              <span>{reservation.guests} personas</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
