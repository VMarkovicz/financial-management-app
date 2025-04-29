import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

class UserRepository extends ChangeNotifier {
  final ApiService _apiService;

  UserRepository(this._apiService);

  Future<User> getUserData(id) => _apiService.getUserData(id);
  
  Future<User> createUser(User user) async {
    final response = await _apiService.createUser(user);
    notifyListeners();
    return response;
  }

  Future<User> loginUser(String email, String password) async {
    final response = await _apiService.loginUser(email, password);
    notifyListeners();
    return response;
  }
  
  Future<User> updateUser(String nome) async {
    final response = await _apiService.updateUser(nome);
    notifyListeners();
    return response;
  }
  
  Future<void> deleteUser(String id) async {
    await _apiService.deleteUser(id);
    notifyListeners();
  }
  
}
