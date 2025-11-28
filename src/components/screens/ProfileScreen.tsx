import { ChevronRight, Bell, Lock, HelpCircle, LogOut } from 'lucide-react';
import { mockUser } from '../../data/mockData';
import { BottomNavigation } from '../BottomNavigation';
import { ImageWithFallback } from '../figma/ImageWithFallback';

interface ProfileScreenProps {
  onNavigate: (screen: string, data?: any) => void;
  onLogout: () => void;
}

export function ProfileScreen({ onNavigate, onLogout }: ProfileScreenProps) {
  const menuItems = [
    {
      icon: Bell,
      label: 'Notificaciones',
      action: () => {},
      hasToggle: true,
      toggleValue: true
    },
    {
      icon: Lock,
      label: 'Privacidad y seguridad',
      action: () => {}
    },
    {
      icon: HelpCircle,
      label: 'Ayuda y soporte',
      action: () => {}
    }
  ];

  return (
    <div className="h-full bg-[#F4F4F4] flex flex-col">
      <div className="bg-white p-4 border-b">
        <h2>Perfil</h2>
      </div>

      <div className="flex-1 overflow-auto pb-20">
        <div className="bg-white p-6 mb-4">
          <div className="flex items-center gap-4 mb-6">
            <ImageWithFallback 
              src={mockUser.avatar} 
              alt={mockUser.name}
              className="w-20 h-20 rounded-full object-cover"
            />
            <div className="flex-1">
              <h2 className="mb-1">{mockUser.name}</h2>
              <p className="text-sm text-gray-600">{mockUser.email}</p>
            </div>
          </div>

          <button
            onClick={() => onNavigate('edit-profile')}
            className="w-full py-3 bg-[#4C7BF3] text-white rounded-2xl hover:bg-[#3a5fc7] transition-colors"
          >
            Editar perfil
          </button>
        </div>

        <div className="bg-white px-4 mb-4">
          <h3 className="py-4">Información personal</h3>
          <div className="space-y-4 pb-4">
            <div className="flex items-center justify-between py-3 border-b">
              <span className="text-gray-600">Correo electrónico</span>
              <span>{mockUser.email}</span>
            </div>
            <div className="flex items-center justify-between py-3 border-b">
              <span className="text-gray-600">Teléfono</span>
              <span>{mockUser.phone}</span>
            </div>
          </div>
        </div>

        <div className="bg-white px-4 mb-4">
          <h3 className="py-4">Ajustes</h3>
          <div className="space-y-2 pb-4">
            {menuItems.map((item, index) => {
              const Icon = item.icon;
              return (
                <button
                  key={index}
                  onClick={item.action}
                  className="w-full flex items-center justify-between py-4 border-b last:border-b-0 hover:bg-gray-50 transition-colors rounded-lg px-2"
                >
                  <div className="flex items-center gap-3">
                    <Icon className="w-5 h-5 text-gray-600" />
                    <span>{item.label}</span>
                  </div>
                  {item.hasToggle ? (
                    <div className={`w-12 h-6 rounded-full transition-colors ${
                      item.toggleValue ? 'bg-[#4C7BF3]' : 'bg-gray-300'
                    }`}>
                      <div className={`w-5 h-5 bg-white rounded-full transition-transform transform ${
                        item.toggleValue ? 'translate-x-6' : 'translate-x-0.5'
                      } mt-0.5`} />
                    </div>
                  ) : (
                    <ChevronRight className="w-5 h-5 text-gray-400" />
                  )}
                </button>
              );
            })}
          </div>
        </div>

        <div className="px-4">
          <button
            onClick={onLogout}
            className="w-full flex items-center justify-center gap-3 py-4 bg-white text-red-500 rounded-2xl hover:bg-red-50 transition-colors"
          >
            <LogOut className="w-5 h-5" />
            <span>Cerrar sesión</span>
          </button>
        </div>
      </div>

      <BottomNavigation currentScreen="profile" onNavigate={onNavigate} />
    </div>
  );
}
