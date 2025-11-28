import { useState } from 'react';
import { SplashScreen } from './components/screens/SplashScreen';
import { LoginScreen } from './components/screens/LoginScreen';
import { RegisterScreen } from './components/screens/RegisterScreen';
import { ForgotPasswordScreen } from './components/screens/ForgotPasswordScreen';
import { HomeScreen } from './components/screens/HomeScreen';
import { ExploreScreen } from './components/screens/ExploreScreen';
import { RestaurantDetailScreen } from './components/screens/RestaurantDetailScreen';
import { CreateReservationScreen } from './components/screens/CreateReservationScreen';
import { ReservationsScreen } from './components/screens/ReservationsScreen';
import { ReservationDetailScreen } from './components/screens/ReservationDetailScreen';
import { ProfileScreen } from './components/screens/ProfileScreen';
import { AddReviewScreen } from './components/screens/AddReviewScreen';
import { NotificationModal } from './components/NotificationModal';
import { Restaurant, Reservation } from './types';

type Screen = 
  | 'splash'
  | 'login'
  | 'register'
  | 'forgot-password'
  | 'home'
  | 'explore'
  | 'restaurant-detail'
  | 'create-reservation'
  | 'reservations'
  | 'reservation-detail'
  | 'profile'
  | 'add-review';

export default function App() {
  const [currentScreen, setCurrentScreen] = useState<Screen>('splash');
  const [screenData, setScreenData] = useState<any>(null);
  const [showNotification, setShowNotification] = useState(false);
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  const navigate = (screen: Screen, data?: any) => {
    setCurrentScreen(screen);
    setScreenData(data);
  };

  const handleLogin = () => {
    setIsAuthenticated(true);
    navigate('home');
  };

  const handleRegister = () => {
    setIsAuthenticated(true);
    navigate('home');
  };

  const handleLogout = () => {
    setIsAuthenticated(false);
    navigate('login');
  };

  const handleSplashComplete = () => {
    navigate('login');
  };

  return (
    <div className="h-screen max-w-md mx-auto bg-white shadow-2xl relative overflow-hidden">
      {currentScreen === 'splash' && (
        <SplashScreen onComplete={handleSplashComplete} />
      )}

      {currentScreen === 'login' && (
        <LoginScreen onLogin={handleLogin} onNavigate={navigate} />
      )}

      {currentScreen === 'register' && (
        <RegisterScreen onRegister={handleRegister} onBack={() => navigate('login')} />
      )}

      {currentScreen === 'forgot-password' && (
        <ForgotPasswordScreen onBack={() => navigate('login')} />
      )}

      {currentScreen === 'home' && (
        <HomeScreen 
          onNavigate={navigate} 
          onShowNotification={() => setShowNotification(true)}
        />
      )}

      {currentScreen === 'explore' && (
        <ExploreScreen onNavigate={navigate} />
      )}

      {currentScreen === 'restaurant-detail' && screenData && (
        <RestaurantDetailScreen
          restaurant={screenData as Restaurant}
          onBack={() => navigate('explore')}
          onNavigate={navigate}
        />
      )}

      {currentScreen === 'create-reservation' && screenData && (
        <CreateReservationScreen
          restaurant={screenData as Restaurant}
          onBack={() => navigate('restaurant-detail', screenData)}
          onConfirm={() => navigate('reservations')}
        />
      )}

      {currentScreen === 'reservations' && (
        <ReservationsScreen onNavigate={navigate} />
      )}

      {currentScreen === 'reservation-detail' && screenData && (
        <ReservationDetailScreen
          reservation={screenData as Reservation}
          onBack={() => navigate('reservations')}
        />
      )}

      {currentScreen === 'profile' && (
        <ProfileScreen onNavigate={navigate} onLogout={handleLogout} />
      )}

      {currentScreen === 'add-review' && screenData && (
        <AddReviewScreen
          restaurant={screenData as Restaurant}
          onBack={() => navigate('restaurant-detail', screenData)}
        />
      )}

      {showNotification && (
        <NotificationModal onClose={() => setShowNotification(false)} />
      )}
    </div>
  );
}
