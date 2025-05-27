import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
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

    String filename = '${response.email}_profile_picture.png';
    var file = await _userRepository.downloadProfilePhoto(filename);
    user = response;
    user.profilePictureUrl = file;
    busy = false;
    notifyListeners();
    return response;
  }

  Future<UserModel> updateUser(String username) async {
    final userProfileUrl = user.profilePictureUrl;
    final response = await _userRepository.updateUser(username);
    user = response;
    user.profilePictureUrl = userProfileUrl;
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

  Future<void> uploadProfilePhoto(File imageFile) async {
    busy = true;
    notifyListeners();
    String filename = '${user.email}_profile_picture.png';
    await _userRepository.uploadProfilePhoto(filename, imageFile);
    Fluttertoast.showToast(
      msg: 'Profile photo updated successfully!',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    busy = false;
    notifyListeners();
  }

  Future<void> getProfilePhotoUrl() async {
    String filename = '${user.email}_profile_picture.png';
    busy = true;
    notifyListeners();
    var file = await _userRepository.downloadProfilePhoto(filename);
    if (file.isNotEmpty) {
      user.profilePictureUrl = file;
      Fluttertoast.showToast(
        msg: 'Profile photo retrieved successfully!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Failed to retrieve profile photo.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    busy = false;
    notifyListeners();
  }
}
