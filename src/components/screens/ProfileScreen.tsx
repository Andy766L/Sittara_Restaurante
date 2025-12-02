import { useState, useEffect } from 'react';
import { ChevronRight, Bell, Lock, HelpCircle, LogOut } from 'lucide-react';
import { supabase } from '../../lib/supabaseClient';
import { signOut } from '../../services/api';
import { BottomNavigation } from '../BottomNavigation';
import { ImageWithFallback } from '../figma/ImageWithFallback';
import { User } from '@supabase/supabase-js';

interface ProfileScreenProps {
  onNavigate: (screen: string, data?: any) => void;
  onLogout: () => void;
}

export function ProfileScreen({ onNavigate, onLogout }: ProfileScreenProps) {
  const [user, setUser] = useState<User | null>(null);

  useEffect(() => {
    const fetchUser = async () => {
      const { data: { session } } = await supabase.auth.getSession();
      setUser(session?.user ?? null);
    };

    fetchUser();

    const { data: authListener } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null);
    });

    return () => {
      authListener.subscription.unsubscribe();
    };
  }, []);

  const handleSignOut = async () => {
    await signOut();
    onLogout();
  };
  
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

  const goldColor = '#D4AF37';
  const userName = user?.user_metadata?.name || user?.email?.split('@')[0] || 'Guest';
  const userEmail = user?.email || '';
  const userAvatar = user?.user_metadata?.avatar_url || 'https://www.gravatar.com/avatar/?d=mp';
  const userPhone = user?.user_metadata?.phone || 'No disponible';

  return (
    <div className="h-full bg-[#F4F4F4] flex flex-col">
      <div className="bg-white p-4 border-b">
        <h2>Perfil</h2>
      </div>

      <div className="flex-1 overflow-auto pb-20">
        <div className="bg-white p-6 mb-4">
          <div className="flex items-center gap-4 mb-6">
            <ImageWithFallback 
              src={userAvatar} 
              alt={userName}
              className="w-20 h-20 rounded-full object-cover"
            />
            <div className="flex-1">
              <h2 className="mb-1">{userName}</h2>
              <p className="text-sm text-gray-600">{userEmail}</p>
            </div>
          </div>

          <button
            onClick={() => onNavigate('edit-profile')}
            style={{ backgroundColor: goldColor }}
            className="w-full py-3 text-black rounded-2xl hover:bg-opacity-90 transition-colors"
          >
            Editar perfil
          </button>
        </div>

        <div className="bg-white px-4 mb-4">
          <h3 className="py-4">Información personal</h3>
          <div className="space-y-4 pb-4">
            <div className="flex items-center justify-between py-3 border-b">
              <span className="text-gray-600">Correo electrónico</span>
              <span>{userEmail}</span>
            </div>
            <div className="flex items-center justify-between py-3 border-b">
              <span className="text-gray-600">Teléfono</span>
              <span>{userPhone}</span>
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
                    <div 
                      style={{ backgroundColor: item.toggleValue ? goldColor : '' }}
                      className={`w-12 h-6 rounded-full transition-colors ${!item.toggleValue && 'bg-gray-300'}`}>
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
            onClick={handleSignOut}
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
