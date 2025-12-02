import { Home, Search, Calendar, User } from 'lucide-react';

interface BottomNavigationProps {
  currentScreen: string;
  onNavigate: (screen: string) => void;
}

export function BottomNavigation({ currentScreen, onNavigate }: BottomNavigationProps) {
  const navItems = [
    { id: 'home', icon: Home, label: 'Inicio' },
    { id: 'explore', icon: Search, label: 'Explorar' },
    { id: 'reservations', icon: Calendar, label: 'Reservas' },
    { id: 'profile', icon: User, label: 'Perfil' }
  ];

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white/80 backdrop-blur-sm border-t border-gray-200/80 safe-bottom">
      <div className="max-w-md mx-auto flex justify-around items-center h-20">
        {navItems.map((item) => {
          const Icon = item.icon;
          const isActive = currentScreen === item.id;
          
          return (
            <button
              key={item.id}
              onClick={() => onNavigate(item.id)}
              className="flex flex-col items-center justify-center flex-1 h-full transition-all duration-300 transform"
            >
              <div className={`relative p-2 rounded-full transition-all duration-300 ${isActive ? 'bg-primary/10' : ''}`}>
                <Icon 
                  className={`w-8 h-8 transition-colors ${
                    isActive ? 'text-primary' : 'text-gray-500'
                  }`}
                />
                {isActive && <div className="absolute -bottom-2 left-1/2 -translate-x-1/2 w-2 h-2 bg-primary rounded-full"></div>}
              </div>
              <span 
                className={`text-sm mt-1 font-semibold ${
                  isActive ? 'text-primary' : 'text-gray-500'
                }`}
              >
                {item.label}
              </span>
            </button>
          );
        })}
      </div>
    </div>
  );
}
