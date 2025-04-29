import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';


class ApiService {
  final _baseUrl = 'example';
  late String mockUserData;

  Future<User> getUserData(String userId) async {
    return User.fromJson(jsonDecode(mockUserData));
  }

  Future<User> createUser(User user) async {
    mockUserData = jsonEncode(user);
    return User.fromJson(jsonDecode(mockUserData));
  }

  Future<User> loginUser(String email, String password) async {
    var existingUser = await getUserData(mockUserData);
    if (existingUser.email == email && existingUser.password == password) {
      return User.fromJson(jsonDecode(mockUserData));
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<User> updateUser(String nome) async {
    var existingUser = await getUserData(mockUserData);
    existingUser.username = nome;
    mockUserData = jsonEncode(existingUser);
    return User.fromJson(jsonDecode(mockUserData));
  }

  Future<void> deleteUser(String id) async {
    mockUserData = '';
  }
}
