import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

class UserRepository extends ChangeNotifier {
  final ApiService _apiService;

  UserRepository(this._apiService);

  Future<UserModel> getUserData(id) => _apiService.getUserData(id);

  Future<UserModel> createUser(UserModel user) async {
    final response = await _apiService.createUser(user);
    return response;
  }

  Future<UserModel> loginUser(String email, String password) async {
    final response = await _apiService.loginUser(email, password);
    return response;
  }

  Future<UserModel> updateUser(String nome) async {
    final response = await _apiService.updateUser(nome);
    return response;
  }

  Future<void> deleteUser(String id) async {
    await _apiService.deleteUser(id);
  }
}
