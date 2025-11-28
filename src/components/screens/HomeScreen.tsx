import { Bell } from 'lucide-react';
import { restaurants, mockUser } from '../../data/mockData';
import { RestaurantCard } from '../RestaurantCard';
import { BottomNavigation } from '../BottomNavigation';

interface HomeScreenProps {
  onNavigate: (screen: string, data?: any) => void;
  onShowNotification: () => void;
}

export function HomeScreen({ onNavigate, onShowNotification }: HomeScreenProps) {
  const featuredRestaurants = restaurants.slice(0, 4);

  return (
    <div className="h-full bg-[#F4F4F4] flex flex-col">
      <div className="bg-white p-4 border-b">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-sm text-gray-600">Hola,</p>
            <h2>{mockUser.name}</h2>
          </div>
          <button 
            onClick={onShowNotification}
            className="relative p-2 hover:bg-gray-100 rounded-full"
          >
            <Bell className="w-6 h-6" />
            <span className="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span>
          </button>
        </div>
      </div>

      <div className="flex-1 overflow-auto pb-20">
        <div className="p-4">
          <div className="bg-gradient-to-r from-[#4C7BF3] to-[#3a5fc7] rounded-2xl p-6 mb-6 text-white">
            <h2 className="mb-2 text-white">Descubre nuevos sabores</h2>
            <p className="text-white/90 mb-4">
              Reserva en los mejores restaurantes de tu ciudad
            </p>
            <button 
              onClick={() => onNavigate('explore')}
              className="bg-white text-[#4C7BF3] px-6 py-2 rounded-full hover:bg-gray-100 transition-colors"
            >
              Explorar ahora
            </button>
          </div>

          <div className="flex items-center justify-between mb-4">
            <h2>Destacados</h2>
            <button 
              onClick={() => onNavigate('explore')}
              className="text-sm text-[#4C7BF3] hover:underline"
            >
              Ver todos
            </button>
          </div>

          <div className="grid grid-cols-1 gap-4">
            {featuredRestaurants.map((restaurant) => (
              <RestaurantCard
                key={restaurant.id}
                restaurant={restaurant}
                onClick={() => onNavigate('restaurant-detail', restaurant)}
              />
            ))}
          </div>
        </div>
      </div>

      <BottomNavigation currentScreen="home" onNavigate={onNavigate} />
    </div>
  );
}
