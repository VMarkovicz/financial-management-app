import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository;

  UserViewModel(this._userRepository);

  User user = User(id: '', username: '', email: '', password: '');
  bool busy = false;

  Future<void> loadUser() async {
    busy = true;
    notifyListeners();
    user = await _userRepository.getUserData('123');
    busy = false;
    notifyListeners();
  }

  Future<User> createUser(User user) async {
    final response = await _userRepository.createUser(user);
    notifyListeners();
    return response;
  }

  Future<User> loginUser(String email, String password) async {
    final response = await _userRepository.loginUser(email, password);
    notifyListeners();
    return response;
  }

  Future<User> updateUser(String nome) async {
    final response = await _userRepository.updateUser(nome);
    user = response;
    notifyListeners();
    return response;
  }

  Future<void> deleteUser(String id) async {
    await _userRepository.deleteUser(id);
    notifyListeners();
  }

  void logoutUser() {
    user = User(id: '', username: '', email: '', password: '');
    notifyListeners();
  }
}
