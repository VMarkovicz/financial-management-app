import 'dart:convert';
import 'package:financial_management_app/models/transaction_model.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

List<Transaction> mockTransactions = [];

class ApiService {
  // final _baseUrl = 'example';
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

  // Transactions
  Future<List<Transaction>> getTransactions(String userId) async {
    // Simulate a network call
    await Future.delayed(Duration(seconds: 1));
    return mockTransactions;
  }

  Future<void> addTransaction(Transaction transaction) async {
    // Simulate a network call
    await Future.delayed(Duration(seconds: 1));
    mockTransactions.add(transaction);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    // Simulate a network call
    await Future.delayed(Duration(seconds: 1));
    final index = mockTransactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      mockTransactions[index] = transaction;
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    await Future.delayed(Duration(seconds: 1));
    mockTransactions.removeWhere((t) => t.id == transactionId);
  }

  Future<List<Transaction>> getTodaysTransaction(DateTime currentDate) async {
    List<Transaction> todayTransactions =
        mockTransactions.where((transaction) {
          DateTime transactionDate = transaction.date;
          return transactionDate.year == currentDate.year &&
              transactionDate.month == currentDate.month &&
              transactionDate.day == currentDate.day;
        }).toList();

    return todayTransactions;
  }
}
