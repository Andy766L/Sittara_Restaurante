import { supabase } from '../lib/supabaseClient';
import { Restaurant, Reservation, Review } from '../types';

// Auth functions
export async function signInWithPassword(email, password) {
  const { data, error } = await supabase.auth.signInWithPassword({ email, password });
  if (error) throw error;
  return data.user;
}

export async function signUp(email, password, options) {
  const { data, error } = await supabase.auth.signUp({ email, password, options });
  if (error) throw error;
  return data.user;
}

export async function signOut() {
  const { error } = await supabase.auth.signOut();
  if (error) throw error;
}


// Data functions
export async function getRestaurants(): Promise<Restaurant[]> {
  const { data, error } = await supabase.from('restaurants').select('*');
  if (error) {
    console.error('Error fetching restaurants:', error);
    return [];
  }
  return data as Restaurant[];
}

export async function getReviewsForRestaurant(restaurantId: string): Promise<Review[]> {
  const { data, error } = await supabase
    .from('reviews')
    .select('*')
    .eq('restaurant_id', restaurantId)
    .order('created_at', { ascending: false });

  if (error) {
    console.error('Error fetching reviews:', error);
    return [];
  }
  return data as Review[];
}

export async function getReservations(): Promise<Reservation[]> {
  const { data: { session }, } = await supabase.auth.getSession();
  if (!session) return [];
  
  const { data, error } = await supabase
    .from('reservations')
    .select('*, restaurants(*)') // Join with restaurants table
    .eq('user_id', session.user.id)
    .order('reservation_date', { ascending: true })
    .order('reservation_time', { ascending: true });

  if (error) {
    console.error('Error fetching reservations:', error);
    return [];
  }
  
  // Map the nested restaurant object to the properties expected by the Reservation type
  const reservationsWithRestaurantData = data.map(res => ({
    ...res,
    restaurantName: res.restaurants.name,
    restaurantImage: res.restaurants.image,
  }));

  return reservationsWithRestaurantData as Reservation[];
}

export async function addReservation(reservation: Omit<Reservation, 'id' | 'restaurantName' | 'restaurantImage' | 'status'>) {
    const { data: { session }, } = await supabase.auth.getSession();
    if (!session) throw new Error('User not logged in');

    const reservationData = {
        ...reservation,
        user_id: session.user.id,
    };
    
    const { error } = await supabase.from('reservations').insert(reservationData);
    if (error) {
        console.error('Error adding reservation:', error);
        throw error;
    }
}

export async function addReview(review: Omit<Review, 'id' | 'userName' | 'userAvatar'>) {
    const { data: { session }, } = await supabase.auth.getSession();
    if (!session) throw new Error('User not logged in');

    const { data: user } = await supabase.from('users').select('name, avatar_url').eq('id', session.user.id).single();

    const reviewData = {
        ...review,
        user_id: session.user.id,
        user_name: user?.name || 'Anonymous',
        user_avatar: user?.avatar_url || '',
    };
    
    const { error } = await supabase.from('reviews').insert(reviewData);
    if (error) {
        console.error('Error adding review:', error);
        throw error;
    }

    // Call the RPC function to increment reviews_count
    await supabase.rpc('increment_reviews_count', { restaurant_id_param: review.restaurantId });
}
