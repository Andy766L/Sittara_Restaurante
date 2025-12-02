import { ArrowLeft, Calendar, Clock, Users, MapPin, Navigation } from 'lucide-react';
import { Reservation } from '../../types';
import { Button } from '../ui/button';
import { ImageWithFallback } from '../figma/ImageWithFallback';

interface ReservationDetailScreenProps {
  reservation: Reservation;
  onBack: () => void;
}

export function ReservationDetailScreen({ reservation, onBack }: ReservationDetailScreenProps) {
  const restaurant = reservation.restaurants; // Get restaurant from nested object
  const goldColor = '#D4AF37';

  const statusColors = {
    pending: 'bg-orange-100 text-orange-700',
    confirmed: 'bg-green-100 text-green-700',
    cancelled: 'bg-red-100 text-red-700'
  };

  const statusLabels = {
    pending: 'Pendiente de confirmación',
    confirmed: 'Confirmada',
    cancelled: 'Cancelada'
  };

  return (
    <div className="h-full bg-white flex flex-col">
      <div className="flex items-center gap-4 p-4 border-b">
        <button onClick={onBack} className="p-2 hover:bg-gray-100 rounded-full">
          <ArrowLeft className="w-6 h-6" />
        </button>
        <h2>Detalle de reserva</h2>
      </div>

      <div className="flex-1 overflow-auto pb-6">
        <div className="relative h-48">
          <ImageWithFallback 
            src={reservation.restaurantImage} 
            alt={reservation.restaurantName}
            className="w-full h-full object-cover"
          />
        </div>

        <div className="p-6">
          <div className={`inline-block px-4 py-2 rounded-full mb-4 ${statusColors[reservation.status]}`}>
            {statusLabels[reservation.status]}
          </div>

          <h1 className="mb-2">{reservation.restaurantName}</h1>
          {restaurant && (
            <p className="text-gray-600 mb-6">{restaurant.address}</p>
          )}

          <div className="space-y-4 mb-6">
            <div className="flex items-center gap-4 p-4 bg-gray-50 rounded-2xl">
              <div style={{ backgroundColor: goldColor }} className="p-3 rounded-full">
                <Calendar className="w-6 h-6 text-white" />
              </div>
              <div>
                <p className="text-sm text-gray-600">Fecha</p>
                <p>
                  {new Date(reservation.date).toLocaleDateString('es-ES', {
                    weekday: 'long',
                    day: 'numeric',
                    month: 'long',
                    year: 'numeric'
                  })}
                </p>
              </div>
            </div>

            <div className="flex items-center gap-4 p-4 bg-gray-50 rounded-2xl">
              <div style={{ backgroundColor: goldColor }} className="p-3 rounded-full">
                <Clock className="w-6 h-6 text-white" />
              </div>
              <div>
                <p className="text-sm text-gray-600">Hora</p>
                <p>{reservation.time}</p>
              </div>
            </div>

            <div className="flex items-center gap-4 p-4 bg-gray-50 rounded-2xl">
              <div style={{ backgroundColor: goldColor }} className="p-3 rounded-full">
                <Users className="w-6 h-6 text-white" />
              </div>
              <div>
                <p className="text-sm text-gray-600">Personas</p>
                <p>{reservation.guests}</p>
              </div>
            </div>
          </div>

          {restaurant && (
            <div className="mb-6">
              <h3 className="mb-3">Ubicación</h3>
              <div className="relative h-48 rounded-2xl overflow-hidden">
                <ImageWithFallback 
                  src="https://images.unsplash.com/photo-1694953592902-46d9b0d0c19d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxyZXN0YXVyYW50JTIwbG9jYXRpb24lMjBtYXB8ZW58MXx8fHwxNjM4NTAxNzN8MA&ixlib=rb-4.1.0&q=80&w=1080"
                  alt="Mapa"
                  className="w-full h-full object-cover"
                />
                <div className="absolute inset-0 flex items-center justify-center">
                  <MapPin style={{ color: goldColor }} className="w-12 h-12" />
                </div>
              </div>
              <Button style={{ borderColor: goldColor, color: goldColor }} className="w-full mt-3 h-12 bg-white border-2 hover:text-white rounded-2xl">
                <Navigation className="w-5 h-5 mr-2" />
                Ver indicaciones
              </Button>
            </div>
          )}

          {reservation.status !== 'cancelled' && (
            <Button className="w-full h-12 bg-red-500 hover:bg-red-600 text-white rounded-2xl">
              Cancelar reserva
            </Button>
          )}
        </div>
      </div>
    </div>
  );
}
