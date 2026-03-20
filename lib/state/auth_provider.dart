import 'package:flutter/material.dart';
import 'package:myapp/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String email, String password) async {
    try {
      await _apiService.login(email, password);
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      rethrow; // Rethrow the exception to be handled in the UI
    }
  }

  Future<void> register(String email, String password) async {
    try {
      await _apiService.register(email, password);
    } catch (e) {
      rethrow; // Rethrow the exception to be handled in the UI
    }
  }

  Future<void> logout() async {
    await _apiService.deleteAllTokens();
    _isAuthenticated = false;
    notifyListeners();
  }
}
