import { Star, MapPin } from 'lucide-react';
import { Restaurant } from '../types';
import { ImageWithFallback } from './figma/ImageWithFallback';

interface RestaurantCardProps {
  restaurant: Restaurant;
  onClick: () => void;
}

export function RestaurantCard({ restaurant, onClick }: RestaurantCardProps) {
  return (
    <div 
      onClick={onClick}
      className="bg-white rounded-2xl overflow-hidden shadow-sm hover:shadow-md transition-shadow cursor-pointer"
    >
      <div className="relative h-48 overflow-hidden">
        <ImageWithFallback 
          src={restaurant.image} 
          alt={restaurant.name}
          className="w-full h-full object-cover"
        />
      </div>
      <div className="p-4">
        <h3 className="mb-1">{restaurant.name}</h3>
        <div className="flex items-center gap-1 mb-2">
          <Star className="w-4 h-4 fill-[#FFC107] text-[#FFC107]" />
          <span className="text-sm text-gray-700">{restaurant.rating}</span>
          <span className="text-sm text-gray-500 ml-1">• {restaurant.cuisine}</span>
        </div>
        <div className="flex items-center gap-1 text-sm text-gray-600">
          <MapPin className="w-4 h-4" />
          <span className="line-clamp-1">{restaurant.address}</span>
        </div>
      </div>
    </div>
  );
}
