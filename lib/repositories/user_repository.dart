import 'dart:convert';
import 'dart:io';

import 'package:financial_management_app/services/auth_service.dart';
import 'package:financial_management_app/services/user_service.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
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

  Future<UserModel> updateDefaultCurrency(String currency) async {
    final response = await _userService.updateDefaultCurrency(currency);
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

  Future<void> uploadProfilePhoto(String filename, File imageFile) async {
    final presignedURLJson = await _userService.getPresignedUrlPutObject(
      filename,
    );

    final presignedURL = Map<String, dynamic>.from(
      jsonDecode(presignedURLJson),
    );
    if (presignedURL.isEmpty || !presignedURL.containsKey('url')) {
      throw Exception('Failed to get presigned URL');
    }

    await _userService.uploadToPresignedUrl(
      presignedURL['url'],
      imageFile,
      filename,
    );
  }

  Future<String> getProfilePhotoUrl(String filename) async {
    var presignedURLJson = await _userService.getPresignedUrlGetObject(
      filename,
    );
    var presignedURL = Map<String, dynamic>.from(jsonDecode(presignedURLJson));
    if (presignedURL.isEmpty || !presignedURL.containsKey('url')) {
      throw Exception('Failed to get presigned URL');
    }
    return presignedURL['url'];
  }

  Future<String> downloadProfilePhoto(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';
    File file = File(filePath);
    if (await file.exists()) {
      debugPrint('File already exists at $filePath');
      return file.path;
    }

    debugPrint('Downloading file to $filePath');

    var presignedURL = await getProfilePhotoUrl(filename);

    final response = await _userService.downloadImage(presignedURL, filename);

    return response.path;
  }
}
