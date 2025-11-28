import { Star } from 'lucide-react';
import { Review } from '../types';
import { ImageWithFallback } from './figma/ImageWithFallback';

interface ReviewCardProps {
  review: Review;
}

export function ReviewCard({ review }: ReviewCardProps) {
  const renderStars = (rating: number) => {
    return Array.from({ length: 5 }, (_, i) => (
      <Star
        key={i}
        className={`w-4 h-4 ${
          i < rating ? 'fill-[#FFC107] text-[#FFC107]' : 'text-gray-300'
        }`}
      />
    ));
  };

  return (
    <div className="bg-white rounded-2xl p-4 shadow-sm">
      <div className="flex items-start gap-3">
        <ImageWithFallback 
          src={review.userAvatar} 
          alt={review.userName}
          className="w-12 h-12 rounded-full object-cover"
        />
        <div className="flex-1">
          <div className="flex items-center justify-between mb-1">
            <span className="text-sm text-gray-600">{review.date}</span>
          </div>
          <div className="flex gap-1 mb-2">
            {renderStars(review.rating)}
          </div>
          <p className="text-sm text-gray-700 leading-relaxed">{review.comment}</p>
        </div>
      </div>
    </div>
  );
}
