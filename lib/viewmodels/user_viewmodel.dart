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
}
