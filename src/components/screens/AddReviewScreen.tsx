import { useState } from 'react';
import { ArrowLeft, Star } from 'lucide-react';
import { Restaurant } from '../../types';
import { Button } from '../ui/button';
import { Textarea } from '../ui/textarea';

interface AddReviewScreenProps {
  restaurant: Restaurant;
  onBack: () => void;
}

export function AddReviewScreen({ restaurant, onBack }: AddReviewScreenProps) {
  const [rating, setRating] = useState(0);
  const [hoveredRating, setHoveredRating] = useState(0);
  const [comment, setComment] = useState('');
  const [submitted, setSubmitted] = useState(false);

  const handleSubmit = () => {
    setSubmitted(true);
    setTimeout(() => {
      onBack();
    }, 2000);
  };

  if (submitted) {
    return (
      <div className="h-full bg-white flex flex-col items-center justify-center p-6">
        <div className="bg-green-100 rounded-full p-8 mb-6 animate-bounce">
          <Star className="w-16 h-16 text-green-600 fill-green-600" />
        </div>
        <h1 className="mb-4 text-center">¡Gracias por tu reseña!</h1>
        <p className="text-center text-gray-600">
          Tu opinión nos ayuda a mejorar
        </p>
      </div>
    );
  }

  return (
    <div className="h-full bg-white flex flex-col">
      <div className="flex items-center gap-4 p-4 border-b">
        <button onClick={onBack} className="p-2 hover:bg-gray-100 rounded-full">
          <ArrowLeft className="w-6 h-6" />
        </button>
        <h2>Agregar reseña</h2>
      </div>

      <div className="flex-1 overflow-auto pb-6">
        <div className="p-6">
          <div className="text-center mb-8">
            <h3 className="mb-2">{restaurant.name}</h3>
            <p className="text-gray-600">¿Cómo fue tu experiencia?</p>
          </div>

          <div className="mb-8">
            <p className="text-center mb-4">Calificación</p>
            <div className="flex justify-center gap-2">
              {[1, 2, 3, 4, 5].map((star) => (
                <button
                  key={star}
                  onClick={() => setRating(star)}
                  onMouseEnter={() => setHoveredRating(star)}
                  onMouseLeave={() => setHoveredRating(0)}
                  className="transition-transform hover:scale-110"
                >
                  <Star
                    className={`w-12 h-12 ${
                      star <= (hoveredRating || rating)
                        ? 'fill-[#FFC107] text-[#FFC107]'
                        : 'text-gray-300'
                    }`}
                  />
                </button>
              ))}
            </div>
            {rating > 0 && (
              <p className="text-center text-gray-600 mt-2">
                {rating === 5 && '¡Excelente!'}
                {rating === 4 && 'Muy bueno'}
                {rating === 3 && 'Bueno'}
                {rating === 2 && 'Regular'}
                {rating === 1 && 'Malo'}
              </p>
            )}
          </div>

          <div className="mb-6">
            <label className="block mb-2">
              Escribe tu opinión
            </label>
            <Textarea
              placeholder="Cuéntanos sobre tu experiencia en el restaurante..."
              value={comment}
              onChange={(e) => setComment(e.target.value)}
              className="min-h-[150px] rounded-2xl border-gray-300 resize-none"
            />
          </div>

          <Button
            onClick={handleSubmit}
            disabled={rating === 0 || comment.trim().length === 0}
            className="w-full h-12 bg-[#4C7BF3] hover:bg-[#3a5fc7] text-white rounded-2xl disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Enviar reseña
          </Button>
        </div>
      </div>
    </div>
  );
}
