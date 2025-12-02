import { useState } from 'react';
import { Utensils, Mail, Lock } from 'lucide-react';
import { Input } from '../ui/input';
import { Button } from '../ui/button';
import { signInWithPassword } from '../../services/api';

interface LoginScreenProps {
  onLogin: () => void;
  onNavigate: (screen: string) => void;
}

export function LoginScreen({ onLogin, onNavigate }: LoginScreenProps) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleLogin = async () => {
    setIsLoading(true);
    setError(null);
    try {
      await signInWithPassword(email, password);
      onLogin();
    } catch (e: any) {
      setError(e.message || 'An unexpected error occurred.');
    } finally {
      setIsLoading(false);
    }
  };

  const goldColor = '#D4AF37';

  return (
    <div className="h-full bg-white flex flex-col">
      <div className="flex-1 flex flex-col items-center justify-center px-6">
        <div style={{ backgroundColor: goldColor }} className="rounded-full p-6 mb-8">
          <Utensils className="w-12 h-12 text-white" />
        </div>
        
        <h1 className="mb-2">Bienvenido a Sittara</h1>
        <p className="text-gray-600 mb-8 text-center">
          Inicia sesión para comenzar a reservar
        </p>

        <div className="w-full max-w-sm space-y-4">
          <div className="relative">
            <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
            <Input
              type="email"
              placeholder="Correo electrónico"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="pl-10 h-12 rounded-2xl border-gray-300"
              disabled={isLoading}
            />
          </div>

          <div className="relative">
            <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
            <Input
              type="password"
              placeholder="Contraseña"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="pl-10 h-12 rounded-2xl border-gray-300"
              disabled={isLoading}
            />
          </div>

          {error && <p className="text-red-500 text-sm text-center">{error}</p>}

          <button
            onClick={() => onNavigate('forgot-password')}
            style={{ color: goldColor }}
            className="text-sm hover:underline"
          >
            ¿Olvidaste tu contraseña?
          </button>

          <Button
            onClick={handleLogin}
            style={{ backgroundColor: goldColor }}
            className="w-full h-12 hover:bg-opacity-90 text-black rounded-2xl"
            disabled={isLoading}
          >
            {isLoading ? 'Iniciando...' : 'Iniciar sesión'}
          </Button>

          <div className="text-center pt-4">
            <span className="text-gray-600">¿No tienes cuenta? </span>
            <button
              onClick={() => onNavigate('register')}
              style={{ color: goldColor }}
              className="hover:underline"
            >
              Regístrate
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
