import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_management_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class UserService {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;

  Future<UserModel> updateUser(String userName) async {
    final user = _authInstance.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    await user.updateProfile(displayName: userName);

    final updatedUser = _authInstance.currentUser;

    return UserModel(
      id: updatedUser?.uid ?? '',
      username: updatedUser?.displayName ?? '',
      email: updatedUser?.email ?? '',
    );
  }

  Future<UserModel> updateDefaultCurrency(String currency) async {
    final user = _authInstance.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    final userDoc = _firestoreInstance.collection('users').doc(user.uid);
    await userDoc.update({'defaultCurrency': currency});

    final userData = await userDoc.get();
    return UserModel.fromJson(userData.data()!);
  }

  Future<void> deleteUser(String id) async {
    final user = _authInstance.currentUser;
    if (user == null || user.uid != id) {
      throw Exception('No user is currently signed in or ID does not match.');
    }

    await user.delete();
  }

  Future<double> updateBalance(double value) async {
    final user = _authInstance.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    final userDoc = _firestoreInstance.collection('users').doc(user.uid);
    final userData = await userDoc.get();

    if (!userData.exists) {
      throw Exception('User document not found.');
    }

    double currentBalance = userData.data()?['balance'] ?? 0.0;
    double newBalance = currentBalance + value;

    await userDoc.update({'balance': newBalance});

    return newBalance;
  }

  Future<String> getPresignedUrlPutObject(String filename) async {
    final user = _authInstance.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    if (dotenv.env['PUT_AWS_LAMBDA_URL'] == null) {
      throw Exception('Environment variable PUT_AWS_LAMBDA_URL is not set.');
    }

    var response = await http.post(
      Uri.parse(dotenv.env['PUT_AWS_LAMBDA_URL']!),
      headers: {'Content-Type': 'application/json'},
      body: '{"filename": "$filename"}',
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get presigned URL: ${response.statusCode}');
    }
  }

  Future<void> uploadToPresignedUrl(
    String presignedUrl,
    File imageFile,
    String fileName,
  ) async {
    try {
      // Read the file as bytes
      List<int> imageBytes = await imageFile.readAsBytes();

      // Make PUT request with binary data
      var response = await http.put(
        Uri.parse(presignedUrl),
        body: imageBytes,
        headers: {
          'Content-Type':
              'image/jpeg', // or 'image/png' depending on your image format
        },
      );
    } catch (e) {
      print('Error uploading image: $e');
      // Handle error
    }
  }
}
