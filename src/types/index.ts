export interface Restaurant {
  id: string;
  name: string;
  image: string;
  address: string;
  rating: number;
  cuisine: string;
  phone: string;
  hours: string;
  description: string;
  lat: number;
  lng: number;
}

export interface Reservation {
  id: string;
  restaurantId: string;
  restaurantName: string;
  restaurantImage: string;
  date: string;
  time: string;
  guests: number;
  status: 'pending' | 'confirmed' | 'cancelled';
}

export interface Review {
  id: string;
  restaurantId: string;
  userName: string;
  userAvatar: string;
  rating: number;
  comment: string;
  date: string;
}

export interface User {
  name: string;
  email: string;
  phone: string;
  avatar: string;
}
