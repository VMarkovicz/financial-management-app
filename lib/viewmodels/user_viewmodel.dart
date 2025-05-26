import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository;

  UserViewModel(this._userRepository);

  UserModel user = UserModel(id: '', username: '', email: '');
  bool busy = false;

  Future<void> createUser(UserRegisterModel user) async {
    busy = true;
    notifyListeners();
    await _userRepository.createUser(user);
    busy = false;
    notifyListeners();
  }

  Future<UserModel> loginUser(String email, String password) async {
    busy = true;
    notifyListeners();
    final response = await _userRepository.loginUser(email, password);
    busy = false;
    notifyListeners();
    user = response;
    return response;
  }

  Future<UserModel> updateUser(String username) async {
    final response = await _userRepository.updateUser(username);
    user = response;
    Fluttertoast.showToast(
      msg: 'User updated successfully!',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    notifyListeners();

    return response;
  }

  Future<void> updateBalance(double value) async {
    busy = true;
    notifyListeners();
    final response = await _userRepository.updateBalance(value);
    user.balance = response;
    busy = false;
    notifyListeners();
  }

  Future<void> deleteUser(String id) async {
    await _userRepository.deleteUser(id);
    Fluttertoast.showToast(
      msg: 'User deleted successfully!',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    user = UserModel(id: '', username: '', email: '');
    notifyListeners();
  }

  Future<void> logoutUser() async {
    await _userRepository.logoutUser();
    Fluttertoast.showToast(
      msg: 'Logged out successfully!',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    user = UserModel(id: '', username: '', email: '');
    notifyListeners();
  }
}
