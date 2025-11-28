import { mockReservations } from '../../data/mockData';
import { ReservationCard } from '../ReservationCard';
import { BottomNavigation } from '../BottomNavigation';

interface ReservationsScreenProps {
  onNavigate: (screen: string, data?: any) => void;
}

export function ReservationsScreen({ onNavigate }: ReservationsScreenProps) {
  const upcomingReservations = mockReservations.filter(r => r.status !== 'cancelled');
  const pastReservations = mockReservations.filter(r => r.status === 'cancelled');

  return (
    <div className="h-full bg-[#F4F4F4] flex flex-col">
      <div className="bg-white p-4 border-b">
        <h2>Mis Reservas</h2>
      </div>

      <div className="flex-1 overflow-auto pb-20">
        <div className="p-4">
          {upcomingReservations.length > 0 && (
            <div className="mb-6">
              <h3 className="mb-4">Próximas</h3>
              <div className="space-y-3">
                {upcomingReservations.map((reservation) => (
                  <ReservationCard
                    key={reservation.id}
                    reservation={reservation}
                    onClick={() => onNavigate('reservation-detail', reservation)}
                  />
                ))}
              </div>
            </div>
          )}

          {pastReservations.length > 0 && (
            <div>
              <h3 className="mb-4">Anteriores</h3>
              <div className="space-y-3">
                {pastReservations.map((reservation) => (
                  <ReservationCard
                    key={reservation.id}
                    reservation={reservation}
                    onClick={() => onNavigate('reservation-detail', reservation)}
                  />
                ))}
              </div>
            </div>
          )}

          {upcomingReservations.length === 0 && pastReservations.length === 0 && (
            <div className="text-center py-12">
              <p className="text-gray-600 mb-4">No tienes reservas aún</p>
              <button
                onClick={() => onNavigate('explore')}
                className="text-[#4C7BF3] hover:underline"
              >
                Explorar restaurantes
              </button>
            </div>
          )}
        </div>
      </div>

      <BottomNavigation currentScreen="reservations" onNavigate={onNavigate} />
    </div>
  );
}
