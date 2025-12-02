import { useState, useEffect } from 'react';
import { ArrowLeft, Star, MapPin, Clock, Phone, Plus } from 'lucide-react';
import { Restaurant, Review } from '../../types';
import { getReviewsForRestaurant } from '../../services/api';
import { ReviewCard } from '../ReviewCard';
import { Button } from '../ui/button';
import { ImageWithFallback } from '../figma/ImageWithFallback';

interface RestaurantDetailScreenProps {
  restaurant: Restaurant;
  onBack: () => void;
  onNavigate: (screen: string, data?: any) => void;
}

export function RestaurantDetailScreen({ restaurant, onBack, onNavigate }: RestaurantDetailScreenProps) {
  const [reviews, setReviews] = useState<Review[]>([]);

  useEffect(() => {
    async function fetchReviews() {
      const data = await getReviewsForRestaurant(restaurant.id);
      setReviews(data);
    }
    fetchReviews();
  }, [restaurant.id]);

  const renderStars = (rating: number) => {
    const fullStars = Math.floor(rating);
    const hasHalfStar = rating % 1 !== 0;
    
    return (
      <div className="flex gap-1">
        {Array.from({ length: fullStars }, (_, i) => (
          <Star key={i} className="w-5 h-5 fill-[#FFC107] text-[#FFC107]" />
        ))}
        {hasHalfStar && (
          <Star className="w-5 h-5 fill-[#FFC107] text-[#FFC107]" style={{ clipPath: 'inset(0 50% 0 0)' }} />
        )}
        {Array.from({ length: 5 - Math.ceil(rating) }, (_, i) => (
          <Star key={`empty-${i}`} className="w-5 h-5 text-gray-300" />
        ))}
      </div>
    );
  };
  
  const goldColor = '#D4AF37';

  return (
    <div className="h-full bg-[#F4F4F4] flex flex-col">
      <div className="relative">
        <ImageWithFallback 
          src={restaurant.image} 
          alt={restaurant.name}
          className="w-full h-64 object-cover"
        />
        <button 
          onClick={onBack}
          className="absolute top-4 left-4 p-2 bg-white rounded-full shadow-lg hover:bg-gray-100"
        >
          <ArrowLeft className="w-6 h-6" />
        </button>
      </div>

      <div className="flex-1 overflow-auto pb-6">
        <div className="bg-white rounded-t-3xl -mt-6 relative z-10 p-6">
          <h1 className="mb-2">{restaurant.name}</h1>
          <p className="text-gray-600 mb-4">{restaurant.cuisine}</p>
          
          <div className="flex items-center gap-2 mb-6">
            {renderStars(restaurant.rating)}
            <span className="ml-2">
              {restaurant.rating} ({reviews.length} reseñas)
            </span>
          </div>

          <Button
            onClick={() => onNavigate('create-reservation', restaurant)}
            style={{ backgroundColor: goldColor }}
            className="w-full h-12 hover:bg-opacity-90 text-black rounded-2xl mb-6"
          >
            Reservar mesa
          </Button>

          <div className="space-y-4 mb-6">
            <div className="flex items-start gap-3 p-4 bg-gray-50 rounded-2xl">
              <MapPin style={{ color: goldColor }} className="w-5 h-5 flex-shrink-0 mt-0.5" />
              <div>
                <p className="text-sm mb-1">Dirección</p>
                <p className="text-sm text-gray-600">{restaurant.address}</p>
              </div>
            </div>

            <div className="flex items-start gap-3 p-4 bg-gray-50 rounded-2xl">
              <Clock style={{ color: goldColor }} className="w-5 h-5 flex-shrink-0 mt-0.5" />
              <div>
                <p className="text-sm mb-1">Horario</p>
                <p className="text-sm text-gray-600">{restaurant.hours}</p>
              </div>
            </div>

            <div className="flex items-start gap-3 p-4 bg-gray-50 rounded-2xl">
              <Phone style={{ color: goldColor }} className="w-5 h-5 flex-shrink-0 mt-0.5" />
              <div>
                <p className="text-sm mb-1">Teléfono</p>
                <p className="text-sm text-gray-600">{restaurant.phone}</p>
              </div>
            </div>
          </div>

          <div className="mb-4">
            <h2 className="mb-1">Sobre este restaurante</h2>
            <p className="text-gray-600 leading-relaxed">{restaurant.description}</p>
          </div>

          <div className="border-t pt-6">
            <div className="flex items-center justify-between mb-4">
              <h2>Reseñas ({reviews.length})</h2>
              <button 
                onClick={() => onNavigate('add-review', restaurant)}
                style={{ backgroundColor: goldColor }}
                className="flex items-center gap-2 px-4 py-2 text-black rounded-full hover:bg-opacity-90 transition-colors"
              >
                <Plus className="w-4 h-4" />
                <span className="text-sm">Agregar</span>
              </button>
            </div>

            <div className="space-y-3">
              {reviews.map((review) => (
                <ReviewCard key={review.id} review={review} />
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
