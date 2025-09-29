import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../constants/app_constants.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;
  String? _token;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _token;
  bool get isAuthenticated => _user != null && _token != null;

  Future<void> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock successful login
      if (email == 'demo@cooperativebank.com' && password == 'password123') {
        _token = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
        _user = User(
          id: '1',
          firstName: 'John',
          lastName: 'Doe',
          email: email,
          phoneNumber: '+1234567890',
          accountNumber: '1234567890',
          balance: 50000.0,
          createdAt: DateTime.now().subtract(const Duration(days: 365)),
          isVerified: true,
        );
        
        // Save token to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.userTokenKey, _token!);
        await prefs.setString(AppConstants.userDataKey, _user!.toJson().toString());
      } else {
        _setError('Invalid email or password');
      }
    } catch (e) {
      _setError('Login failed. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock successful registration
      _token = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
      _user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        accountNumber: '${DateTime.now().millisecondsSinceEpoch}',
        balance: 0.0,
        createdAt: DateTime.now(),
        isVerified: false,
      );
      
      // Save token to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userTokenKey, _token!);
      await prefs.setString(AppConstants.userDataKey, _user!.toJson().toString());
    } catch (e) {
      _setError('Registration failed. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    _clearError();
    
    // Clear local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userTokenKey);
    await prefs.remove(AppConstants.userDataKey);
    
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.userTokenKey);
    final userData = prefs.getString(AppConstants.userDataKey);
    
    if (token != null && userData != null) {
      _token = token;
      // In a real app, you would parse the user data properly
      // For now, we'll create a mock user
      _user = User(
        id: '1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'demo@cooperativebank.com',
        phoneNumber: '+1234567890',
        accountNumber: '1234567890',
        balance: 50000.0,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        isVerified: true,
      );
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
