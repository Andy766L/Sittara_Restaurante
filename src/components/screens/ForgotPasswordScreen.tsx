import { useState } from 'react';
import { ArrowLeft, Mail } from 'lucide-react';
import { Input } from '../ui/input';
import { Button } from '../ui/button';

interface ForgotPasswordScreenProps {
  onBack: () => void;
}

export function ForgotPasswordScreen({ onBack }: ForgotPasswordScreenProps) {
  const [email, setEmail] = useState('');
  const [sent, setSent] = useState(false);

  const handleSend = () => {
    setSent(true);
  };

  return (
    <div className="h-full bg-white flex flex-col">
      <div className="flex items-center gap-4 p-4 border-b">
        <button onClick={onBack} className="p-2 hover:bg-gray-100 rounded-full">
          <ArrowLeft className="w-6 h-6" />
        </button>
        <h2>Recuperar contraseña</h2>
      </div>

      <div className="flex-1 flex flex-col items-center justify-center px-6">
        {!sent ? (
          <>
            <div className="w-full max-w-sm text-center mb-8">
              <p className="text-gray-600">
                Ingresa tu correo electrónico y te enviaremos instrucciones para recuperar tu contraseña
              </p>
            </div>

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

              <Button
                onClick={handleSend}
                className="w-full h-12 bg-[#4C7BF3] hover:bg-[#3a5fc7] text-white rounded-2xl"
              >
                Enviar instrucciones
              </Button>
            </div>
          </>
        ) : (
          <div className="w-full max-w-sm text-center">
            <div className="bg-green-100 rounded-full p-6 w-20 h-20 mx-auto mb-6 flex items-center justify-center">
              <Mail className="w-10 h-10 text-green-600" />
            </div>
            <h2 className="mb-4">Correo enviado</h2>
            <p className="text-gray-600 mb-8">
              Revisa tu correo electrónico para seguir las instrucciones de recuperación
            </p>
            <Button
              onClick={onBack}
              className="w-full h-12 bg-[#4C7BF3] hover:bg-[#3a5fc7] text-white rounded-2xl"
            >
              Volver al inicio
            </Button>
          </div>
        )}
      </div>
    </div>
  );
}
