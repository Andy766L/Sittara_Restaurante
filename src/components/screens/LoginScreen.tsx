import { useState } from 'react';
import { Utensils, Mail, Lock } from 'lucide-react';
import { Input } from '../ui/input';
import { Button } from '../ui/button';

interface LoginScreenProps {
  onLogin: () => void;
  onNavigate: (screen: string) => void;
}

export function LoginScreen({ onLogin, onNavigate }: LoginScreenProps) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleLogin = () => {
    onLogin();
  };

  return (
    <div className="h-full bg-white flex flex-col">
      <div className="flex-1 flex flex-col items-center justify-center px-6">
        <div className="bg-[#4C7BF3] rounded-full p-6 mb-8">
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
            />
          </div>

          <button
            onClick={() => onNavigate('forgot-password')}
            className="text-sm text-[#4C7BF3] hover:underline"
          >
            ¿Olvidaste tu contraseña?
          </button>

          <Button
            onClick={handleLogin}
            className="w-full h-12 bg-[#4C7BF3] hover:bg-[#3a5fc7] text-white rounded-2xl"
          >
            Iniciar sesión
          </Button>

          <div className="text-center pt-4">
            <span className="text-gray-600">¿No tienes cuenta? </span>
            <button
              onClick={() => onNavigate('register')}
              className="text-[#4C7BF3] hover:underline"
            >
              Regístrate
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
