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
      className="bg-surface rounded-3xl overflow-hidden shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1 cursor-pointer border border-gray-200/50"
    >
      <div className="relative h-56 overflow-hidden">
        <ImageWithFallback 
          src={restaurant.image} 
          alt={restaurant.name}
          className="w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent"></div>
        <div className="absolute bottom-4 left-4">
          <h3 className="text-white text-2xl font-bold">{restaurant.name}</h3>
          <p className="text-white/90 text-sm">{restaurant.cuisine}</p>
        </div>
      </div>
      <div className="p-4">
        <div className="flex items-center justify-between mb-2">
          <div className="flex items-center gap-1">
            <Star className="w-5 h-5 fill-accent text-accent" />
            <span className="text-lg font-bold text-text">{restaurant.rating}</span>
          </div>
          <span className="text-sm text-gray-500">{restaurant.reviews} reviews</span>
        </div>
        <div className="flex items-start gap-2 text-sm text-text-secondary">
          <MapPin className="w-5 h-5 mt-0.5 shrink-0" />
          <span className="line-clamp-2">{restaurant.address}</span>
        </div>
      </div>
    </div>
  );
}
