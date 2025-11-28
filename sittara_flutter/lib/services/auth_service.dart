import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  Future<User?> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // This is a mock authentication.
    // In a real app, you would make an API call.
    if (email.toLowerCase() == mockUser.email.toLowerCase() && password == 'password123') {
      _currentUser = mockUser;
      notifyListeners(); // Notify widgets that are listening to this service
      return _currentUser;
    } else {
      return null;
    }
  }

  Future<User> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    // Simulate network delay for registration
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, this would create a new user in the backend.
    // Here, we'll create a new User object and log them in immediately.
    _currentUser = User(
      name: name,
      email: email,
      phone: phone,
      avatar: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=200&h=200&fit=crop', // A generic new user avatar
    );
    
    notifyListeners();
    return _currentUser!;
  }

  Future<void> logout() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    notifyListeners();
  }
}
