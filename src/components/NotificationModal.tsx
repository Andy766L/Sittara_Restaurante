import { X, CheckCircle } from 'lucide-react';

interface NotificationModalProps {
  onClose: () => void;
}

export function NotificationModal({ onClose }: NotificationModalProps) {
  return (
    <div className="fixed inset-0 bg-black/50 flex items-end justify-center z-50 animate-in fade-in">
      <div className="bg-white rounded-t-3xl w-full max-w-md p-6 animate-in slide-in-from-bottom duration-300">
        <div className="flex items-center justify-between mb-6">
          <h2>Notificaciones</h2>
          <button 
            onClick={onClose}
            className="p-2 hover:bg-gray-100 rounded-full"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        <div className="space-y-4">
          <div className="flex gap-4 p-4 bg-green-50 rounded-2xl">
            <div className="bg-green-500 p-2 rounded-full h-fit">
              <CheckCircle className="w-6 h-6 text-white" />
            </div>
            <div className="flex-1">
              <h3 className="text-sm mb-1">Reserva confirmada</h3>
              <p className="text-sm text-gray-600">
                Tu reserva en La Bella Italia para el 25 de noviembre a las 20:00 ha sido confirmada
              </p>
              <span className="text-xs text-gray-500 mt-2 block">Hace 2 horas</span>
            </div>
          </div>

          <div className="flex gap-4 p-4 bg-blue-50 rounded-2xl">
            <div className="bg-[#4C7BF3] p-2 rounded-full h-fit">
              <CheckCircle className="w-6 h-6 text-white" />
            </div>
            <div className="flex-1">
              <h3 className="text-sm mb-1">Nueva recomendación</h3>
              <p className="text-sm text-gray-600">
                Hemos encontrado un nuevo restaurante que podría gustarte: Sakura Sushi
              </p>
              <span className="text-xs text-gray-500 mt-2 block">Hace 5 horas</span>
            </div>
          </div>

          <div className="flex gap-4 p-4 bg-orange-50 rounded-2xl">
            <div className="bg-orange-500 p-2 rounded-full h-fit">
              <CheckCircle className="w-6 h-6 text-white" />
            </div>
            <div className="flex-1">
              <h3 className="text-sm mb-1">Recordatorio</h3>
              <p className="text-sm text-gray-600">
                Tu reserva en Sakura Sushi es mañana a las 19:30
              </p>
              <span className="text-xs text-gray-500 mt-2 block">Hace 1 día</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
