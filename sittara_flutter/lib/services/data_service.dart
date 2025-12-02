import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models.dart';
import '../services/supabase_service.dart';

class DataService extends ChangeNotifier {
  List<Restaurant> _restaurants = [];
  List<Reservation> _reservations = [];
  // Reviews are fetched dynamically per restaurant, not stored globally here

  List<Restaurant> get restaurants => _restaurants;
  List<Reservation> get reservations => _reservations;

  Future<void> fetchInitialData() async {
    await getRestaurants();
    // Reservations are user-specific, so they will be fetched when needed for a logged-in user
  }

  Future<void> getRestaurants() async {
    try {
      final response = await supabase.from('restaurants').select('*');
      _restaurants = response.map((json) => Restaurant.fromJson(json)).toList();
      notifyListeners();
    } catch (error) {
      print('Error fetching restaurants: $error');
      // Handle error, e.g., show a message to the user
    }
  }

  Future<List<Review>> getReviewsForRestaurant(String restaurantId) async {
    try {
      final response = await supabase
          .from('reviews')
          .select('*')
          .eq('restaurant_id', restaurantId)
          .order('created_at', ascending: false);
      return response.map((json) => Review.fromJson(json)).toList();
    } catch (error) {
      print('Error fetching reviews: $error');
      // Handle error
      return [];
    }
  }

  Future<void> getReservations() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      _reservations = [];
      notifyListeners();
      return;
    }
    try {
      final response = await supabase
          .from('reservations')
          .select('*')
          .eq('user_id', userId)
          .order('reservation_date', ascending: true)
          .order('reservation_time', ascending: true);
      _reservations = response.map((json) => Reservation.fromJson(json)).toList();
      notifyListeners();
    } catch (error) {
      print('Error fetching reservations: $error');
      // Handle error
    }
  }

  Future<void> addReservation(Reservation reservation) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in to add reservation');
    }
    try {
      final Map<String, dynamic> reservationData = reservation.toJson();
      reservationData['user_id'] = userId; // Add user_id to the data
      
      // For denormalized fields like restaurantName/Image, we'll fetch them if not already present or rely on a Supabase function/trigger
      // For now, we'll assume the front-end displays them correctly based on restaurantId.
      // We are explicitly NOT sending restaurantName and restaurantImage to DB as per toJson() logic.

      await supabase.from('reservations').insert(reservationData);
      await getReservations(); // Refresh reservations list
    } catch (error) {
      print('Error adding reservation: $error');
      rethrow;
    }
  }

  Future<void> addReview(Review review) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in to add review');
    }
    try {
      final Map<String, dynamic> reviewData = review.toJson();
      reviewData['user_id'] = userId; // Add user_id to the data
      
      await supabase.from('reviews').insert(reviewData);

      // Increment reviews_count for the restaurant
      await supabase.rpc('increment_reviews_count', params: {'restaurant_id_param': review.restaurantId});

      await getRestaurants(); // Refresh restaurants to update reviews_count
      // Reviews are fetched dynamically per restaurant, no global list to update
    } catch (error) {
      print('Error adding review: $error');
      rethrow;
    }
  }
}