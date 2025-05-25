import 'package:financial_management_app/services/auth_service.dart';
import 'package:financial_management_app/services/user_service.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/transactions_service.dart';

class UserRepository extends ChangeNotifier {
  final ApiService _apiService;
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  UserRepository(this._apiService);

  Future<void> createUser(UserRegisterModel user) async {
    await _authService.signUp(user);
  }

  Future<UserModel> loginUser(String email, String password) async {
    final response = await _authService.loginUser(email, password);
    return response;
  }

  Future<UserModel> updateUser(String username) async {
    final response = await _userService.updateUser(username);
    return response;
  }

  Future<double> updateBalance(double value) async {
    return await _userService.updateBalance(value);
  }

  Future<void> logoutUser() async {
    await _authService.logoutUser();
  }

  Future<void> deleteUser(String id) async {
    await _userService.deleteUser(id);
  }
}
