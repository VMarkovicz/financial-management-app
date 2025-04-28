import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

const mockUserData = '''
{
  "id": "1",
  "username": "John Doe",
  "email": "jhon@gmail.com",
  "password": "password123"
}
''';

class ApiService {
  final _baseUrl = 'example';

  Future<User> getUserData(String userId) async {
    return User.fromJson(jsonDecode(mockUserData));
  }
}
