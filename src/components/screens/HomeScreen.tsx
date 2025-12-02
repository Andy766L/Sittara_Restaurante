import { useState, useEffect } from 'react';
import { Bell } from 'lucide-react';
import { getRestaurants } from '../../services/api';
import { supabase } from '../../lib/supabaseClient';
import { Restaurant } from '../../types';
import { User } from '@supabase/supabase-js';
import { RestaurantCard } from '../RestaurantCard';
import { BottomNavigation } from '../BottomNavigation';

interface HomeScreenProps {
  onNavigate: (screen: string, data?: any) => void;
  onShowNotification: () => void;
}

export function HomeScreen({ onNavigate, onShowNotification }: HomeScreenProps) {
  const [user, setUser] = useState<User | null>(null);
  const [restaurants, setRestaurants] = useState<Restaurant[]>([]);

  useEffect(() => {
    const fetchData = async () => {
      const { data: { session } } = await supabase.auth.getSession();
      setUser(session?.user ?? null);
      
      const restaurantData = await getRestaurants();
      setRestaurants(restaurantData);
    };

    fetchData();
    
    const { data: authListener } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null);
    });

    return () => {
      authListener.subscription.unsubscribe();
    };
  }, []);

  const featuredRestaurants = restaurants.slice(0, 4);
  const goldColor = '#D4AF37';
  const userName = user?.user_metadata?.name || user?.email?.split('@')[0] || 'Guest';

  return (
    <div className="h-full bg-[#F4F4F4] flex flex-col">
      <div className="bg-white p-4 border-b">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-sm text-gray-600">Hola,</p>
            <h2>{userName}</h2>
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
          <div style={{ backgroundColor: goldColor }} className="bg-gradient-to-r rounded-2xl p-6 mb-6 text-black">
            <h2 className="mb-2 text-black">Descubre nuevos sabores</h2>
            <p className="text-black/90 mb-4">
              Reserva en los mejores restaurantes de tu ciudad
            </p>
            <button 
              onClick={() => onNavigate('explore')}
              className="bg-white text-black px-6 py-2 rounded-full hover:bg-gray-100 transition-colors"
            >
              Explorar ahora
            </button>
          </div>

          <div className="flex items-center justify-between mb-4">
            <h2>Destacados</h2>
            <button 
              onClick={() => onNavigate('explore')}
              style={{ color: goldColor }}
              className="text-sm hover:underline"
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
