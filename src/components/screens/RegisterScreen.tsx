import { useState } from 'react';
import { ArrowLeft, User, Mail, Lock, Phone } from 'lucide-react';
import { Input } from '../ui/input';
import { Button } from '../ui/button';

interface RegisterScreenProps {
  onRegister: () => void;
  onBack: () => void;
}

export function RegisterScreen({ onRegister, onBack }: RegisterScreenProps) {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');

  return (
    <div className="h-full bg-white flex flex-col">
      <div className="flex items-center gap-4 p-4 border-b">
        <button onClick={onBack} className="p-2 hover:bg-gray-100 rounded-full">
          <ArrowLeft className="w-6 h-6" />
        </button>
        <h2>Crear cuenta</h2>
      </div>

      <div className="flex-1 overflow-auto px-6 py-8">
        <p className="text-gray-600 mb-8 text-center">
          Completa tus datos para registrarte
        </p>

        <div className="w-full max-w-sm mx-auto space-y-4">
          <div className="relative">
            <User className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
            <Input
              type="text"
              placeholder="Nombre completo"
              value={name}
              onChange={(e) => setName(e.target.value)}
              className="pl-10 h-12 rounded-2xl border-gray-300"
            />
          </div>

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
            <Phone className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
            <Input
              type="tel"
              placeholder="Teléfono"
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
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

          <Button
            onClick={onRegister}
            className="w-full h-12 bg-[#4C7BF3] hover:bg-[#3a5fc7] text-white rounded-2xl mt-6"
          >
            Crear cuenta
          </Button>

          <div className="text-center pt-4">
            <span className="text-gray-600">¿Ya tienes cuenta? </span>
            <button
              onClick={onBack}
              className="text-[#4C7BF3] hover:underline"
            >
              Inicia sesión
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
