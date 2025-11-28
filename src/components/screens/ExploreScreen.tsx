import { useState } from 'react';
import { Search, MapPin } from 'lucide-react';
import { restaurants } from '../../data/mockData';
import { RestaurantCard } from '../RestaurantCard';
import { BottomNavigation } from '../BottomNavigation';
import { Input } from '../ui/input';
import { ImageWithFallback } from '../figma/ImageWithFallback';

interface ExploreScreenProps {
  onNavigate: (screen: string, data?: any) => void;
}

export function ExploreScreen({ onNavigate }: ExploreScreenProps) {
  const [activeTab, setActiveTab] = useState<'list' | 'map'>('list');
  const [searchQuery, setSearchQuery] = useState('');

  const filteredRestaurants = restaurants.filter(r => 
    r.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    r.cuisine.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <div className="h-full bg-[#F4F4F4] flex flex-col">
      <div className="bg-white p-4 border-b">
        <h2 className="mb-4">Explorar</h2>
        
        <div className="relative mb-4">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
          <Input
            type="text"
            placeholder="Buscar restaurantes..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="pl-10 h-12 rounded-2xl border-gray-300"
          />
        </div>

        <div className="flex gap-2">
          <button
            onClick={() => setActiveTab('list')}
            className={`flex-1 py-2 px-4 rounded-full transition-colors ${
              activeTab === 'list'
                ? 'bg-[#4C7BF3] text-white'
                : 'bg-gray-100 text-gray-700'
            }`}
          >
            Lista
          </button>
          <button
            onClick={() => setActiveTab('map')}
            className={`flex-1 py-2 px-4 rounded-full transition-colors ${
              activeTab === 'map'
                ? 'bg-[#4C7BF3] text-white'
                : 'bg-gray-100 text-gray-700'
            }`}
          >
            Mapa
          </button>
        </div>
      </div>

      <div className="flex-1 overflow-auto pb-20">
        {activeTab === 'list' ? (
          <div className="p-4 grid grid-cols-1 gap-4">
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
              src="https://images.unsplash.com/photo-1694953592902-46d9b0d0c19d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxyZXN0YXVyYW50JTIwbG9jYXRpb24lMjBtYXB8ZW58MXx8fHwxNjM4NTAxNzN8MA&ixlib=rb-4.1.0&q=80&w=1080"
              alt="Mapa"
              className="w-full h-full object-cover"
            />
            
            {/* Marcadores simulados en el mapa */}
            <div className="absolute top-1/4 left-1/3 transform -translate-x-1/2">
              <button className="bg-[#4C7BF3] text-white p-3 rounded-full shadow-lg hover:scale-110 transition-transform">
                <MapPin className="w-6 h-6" />
              </button>
            </div>
            <div className="absolute top-1/2 right-1/4 transform -translate-x-1/2">
              <button className="bg-[#4C7BF3] text-white p-3 rounded-full shadow-lg hover:scale-110 transition-transform">
                <MapPin className="w-6 h-6" />
              </button>
            </div>
            <div className="absolute bottom-1/3 left-1/2 transform -translate-x-1/2">
              <button className="bg-[#4C7BF3] text-white p-3 rounded-full shadow-lg hover:scale-110 transition-transform">
                <MapPin className="w-6 h-6" />
              </button>
            </div>

            {/* Card flotante */}
            <div className="absolute bottom-24 left-4 right-4">
              <div 
                onClick={() => onNavigate('restaurant-detail', restaurants[0])}
                className="bg-white rounded-2xl shadow-xl overflow-hidden cursor-pointer hover:shadow-2xl transition-shadow"
              >
                <div className="flex">
                  <div className="w-24 h-24 flex-shrink-0">
                    <ImageWithFallback 
                      src={restaurants[0].image} 
                      alt={restaurants[0].name}
                      className="w-full h-full object-cover"
                    />
                  </div>
                  <div className="flex-1 p-3">
                    <h3 className="text-sm mb-1">{restaurants[0].name}</h3>
                    <p className="text-xs text-gray-600 mb-1">{restaurants[0].cuisine}</p>
                    <div className="flex items-center gap-1">
                      <span className="text-xs text-gray-700">⭐ {restaurants[0].rating}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>

      <BottomNavigation currentScreen="explore" onNavigate={onNavigate} />
    </div>
  );
}
