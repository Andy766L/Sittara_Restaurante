import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models.dart';
import '../services/supabase_service.dart';

typedef SupabaseUser = User; // Alias for clarity, avoid conflicts with our models.User

class AuthService extends ChangeNotifier {
  models.User? _currentUser; // Use models.User to avoid conflict

  models.User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  AuthService() {
    _currentUser = _mapSupabaseUserToAppUser(supabase.auth.currentUser);
    supabase.auth.onAuthStateChange.listen((data) {
      _currentUser = _mapSupabaseUserToAppUser(data.session?.user);
      notifyListeners();
    });
  }

  models.User? _mapSupabaseUserToAppUser(SupabaseUser? sbUser) {
    if (sbUser == null) return null;
    return models.User(
      name: sbUser.userMetadata?['name'] ?? sbUser.email?.split('@').first ?? 'User',
      email: sbUser.email!,
      phone: sbUser.userMetadata?['phone'] ?? '',
      avatar: sbUser.userMetadata?['avatar_url'] ?? 'https://www.gravatar.com/avatar/?d=mp', // Default avatar
    );
  }

  Future<models.User?> login(String email, String password) async {
    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _currentUser = _mapSupabaseUserToAppUser(response.user);
      notifyListeners();
      return _currentUser;
    } on AuthException catch (e) {
      print('Supabase login error: ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected login error: $e');
      return null;
    }
  }

  Future<models.User?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final AuthResponse response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'phone': phone}, // Store name and phone in user_metadata
      );
      _currentUser = _mapSupabaseUserToAppUser(response.user);
      notifyListeners();
      return _currentUser;
    } on AuthException catch (e) {
      print('Supabase registration error: ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected registration error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
    // The onAuthStateChange listener will handle setting _currentUser to null
    notifyListeners();
  }
}
