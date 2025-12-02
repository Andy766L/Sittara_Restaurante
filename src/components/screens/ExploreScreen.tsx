import { useState, useEffect } from 'react';
import { Search, MapPin, List } from 'lucide-react';
import { getRestaurants } from '../../services/api';
import { Restaurant } from '../../types';
import { RestaurantCard } from '../RestaurantCard';
import { BottomNavigation } from '../BottomNavigation';
import { Input } from '../ui/input';
import { ImageWithFallback } from '../figma/ImageWithFallback';

interface ExploreScreenProps {
  onNavigate: (screen: string, data?: any) => void;
}

export function ExploreScreen({ onNavigate }: ExploreScreenProps) {
  const [restaurants, setRestaurants] = useState<Restaurant[]>([]);
  const [activeTab, setActiveTab] = useState<'list' | 'map'>('list');
  const [searchQuery, setSearchQuery] = useState('');

  useEffect(() => {
    async function fetchRestaurants() {
      const data = await getRestaurants();
      setRestaurants(data);
    }
    fetchRestaurants();
  }, []);

  const filteredRestaurants = restaurants.filter(r => 
    r.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    r.cuisine.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <div className="h-full bg-background flex flex-col">
      <div className="p-6">
        <h1 className="text-3xl font-bold mb-6">Explora Restaurantes</h1>
        
        <div className="relative mb-6">
          <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-6 h-6 text-gray-400" />
          <Input
            type="text"
            placeholder="Busca por nombre o tipo de cocina"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="pl-12 h-14 text-lg rounded-2xl border-2 border-surface focus:border-primary transition-colors"
          />
        </div>

        <div className="flex justify-center gap-4 mb-4">
          <button
            onClick={() => setActiveTab('list')}
            className={`flex items-center gap-2 py-3 px-6 rounded-full text-lg font-semibold transition-all duration-300 ${
              activeTab === 'list'
                ? 'bg-primary text-white shadow-lg'
                : 'bg-white text-text-secondary hover:bg-surface'
            }`}
          >
            <List className="w-6 h-6" />
            <span>Lista</span>
          </button>
          <button
            onClick={() => setActiveTab('map')}
            className={`flex items-center gap-2 py-3 px-6 rounded-full text-lg font-semibold transition-all duration-300 ${
              activeTab === 'map'
                ? 'bg-primary text-white shadow-lg'
                : 'bg-white text-text-secondary hover:bg-surface'
            }`}
          >
            <MapPin className="w-6 h-6" />
            <span>Mapa</span>
          </button>
        </div>
      </div>

      <div className="flex-1 overflow-auto pb-24">
        {activeTab === 'list' ? (
          <div className="px-6 grid grid-cols-1 gap-6">
            {filteredRestaurants.map((restaurant) => (
              <RestaurantCard
                key={restaurant.id}
                restaurant={restaurant}
                onClick={() => onNavigate('restaurant-detail', restaurant)}
              />
            ))}
          </div>
        ) : (
          <div className="relative h-full">
            <ImageWithFallback 
              src="https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"
              alt="Mapa"
              className="w-full h-full object-cover"
            />
            
            {/* Marcadores simulados en el mapa */}
            {restaurants.slice(0, 3).map((restaurant, i) => (
              <div 
                key={i}
                className="absolute"
                style={{ top: `${20 + i * 25}%`, left: `${25 + i * 15}%`}}
              >
                <button 
                  onClick={() => onNavigate('restaurant-detail', restaurant)}
                  className="bg-primary text-white p-3 rounded-full shadow-2xl hover:scale-110 transition-transform border-4 border-white"
                >
                  <MapPin className="w-8 h-8" />
                </button>
              </div>
            ))}
          </div>
        )}
      </div>

      <BottomNavigation currentScreen="explore" onNavigate={onNavigate} />
    </div>
  );
}
