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

  Future<void> deleteUser(String id, UserModel user) async {
    if (user.id != id) {
      throw Exception('User ID does not match the authenticated user.');
    }
    if (user.profilePictureUrl != null && user.profilePictureUrl!.isNotEmpty) {
      await _userService.deleteProfilePictureS3(user.profilePictureUrl!);
    }
    await _userService.deleteUser(id);
  }

  Future<String> uploadProfilePhoto(
    String filename,
    File imageFile,
    String? oldProfilePictureUrl,
  ) async {
    final response = await _userService.getPresignedUrlPutObject(filename);

    if (response.isEmpty || !response.containsKey('url')) {
      throw Exception('Failed to get presigned URL');
    }
    debugPrint('Presigned URL: ${response['url']}');

    try {
      await _userService.uploadToPresignedUrl(response['url']!, imageFile);

      await _userService.updateProfilePicture(response['profilePictureUrl']!);

      if (oldProfilePictureUrl != null && oldProfilePictureUrl.isNotEmpty) {
        debugPrint('Deleting old profile picture: $oldProfilePictureUrl');
        await _userService.deleteProfilePictureS3(oldProfilePictureUrl);
      }

      return response['profilePictureUrl']!;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
