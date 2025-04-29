import 'dart:convert';
import 'dart:math';

import 'package:financial_management_app/models/transaction_model.dart';
import 'package:financial_management_app/widgets/bar_chart.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

import '../models/user_model.dart';

List<Transaction> mockTransactions = [];

class ApiService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final _baseUrl = 'example';
  late String mockUserData;
  final random = Random();

  Future<UserModel> getUserData(String userId) async {
    return UserModel.fromJson(jsonDecode(mockUserData));
  }

  Future<UserModel> createUser(UserModel user) async {
    mockUserData = jsonEncode(user);
    return UserModel.fromJson(jsonDecode(mockUserData));
  }

  Future<UserModel> loginUser(String email, String password) async {
    var existingUser = await getUserData(mockUserData);
    if (existingUser.email == email && existingUser.password == password) {
      return UserModel.fromJson(jsonDecode(mockUserData));
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<UserModel> updateUser(String nome) async {
    var existingUser = await getUserData(mockUserData);
    existingUser.username = nome;
    mockUserData = jsonEncode(existingUser);
    return UserModel.fromJson(jsonDecode(mockUserData));
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

  Future<Map<DateTime, int>> getDayBalanceByMonth(DateTime date) async {
    await Future.delayed(Duration(seconds: 1));
    if (date.month == 4) {
      return {
        DateTime(2025, 4, 6): 1,
        DateTime(2025, 4, 7): 2,
        DateTime(2025, 4, 8): 1,
        DateTime(2025, 4, 9): 2,
        DateTime(2025, 4, 13): 1,
      };
    }
    if (date.month == 5) {
      return {
        DateTime(2025, 5, 6): 1,
        DateTime(2025, 5, 7): 2,
        DateTime(2025, 5, 8): 1,
        DateTime(2025, 5, 9): 2,
        DateTime(2025, 5, 13): 1,
      };
    }
    if (date.month == 3) {
      return {
        DateTime(2025, 3, 6): 1,
        DateTime(2025, 3, 7): 2,
        DateTime(2025, 3, 8): 1,
        DateTime(2025, 3, 9): 2,
        DateTime(2025, 3, 13): 1,
      };
    } else {
      return {};
    }
  }

  Future<List<ChartData>> getExpensesByWeek(
    DateTime weekStart,
    DateTime weekEnd,
  ) async {
    await Future.delayed(Duration(milliseconds: 200));
    return [
      ChartData(value: (100 + random.nextInt(1100)).toDouble(), label: "Sun"),
      ChartData(value: (100 + random.nextInt(1100)).toDouble(), label: "Mon"),
      ChartData(value: (100 + random.nextInt(1100)).toDouble(), label: "Tue"),
      ChartData(value: (100 + random.nextInt(1100)).toDouble(), label: "Wed"),
      ChartData(value: (100 + random.nextInt(1100)).toDouble(), label: "Thu"),
      ChartData(value: (100 + random.nextInt(1100)).toDouble(), label: "Fri"),
      ChartData(value: (100 + random.nextInt(1100)).toDouble(), label: "Sat"),
    ];
  }

  Future<List<ChartData>> getIncomesByWeek(
    DateTime weekStart,
    DateTime weekEnd,
  ) async {
    await Future.delayed(Duration(milliseconds: 200));
    return [
      ChartData(value: (100 + random.nextInt(1100)).toDouble(), label: "Sun"),
      ChartData(value: (100 + random.nextInt(1100)).toDouble(), label: "Mon"),
      ChartData(value: (100 + random.nextInt(1100)).toDouble(), label: "Tue"),
      ChartData(value: (100 + random.nextInt(1100)).toDouble(), label: "Wed"),
      ChartData(value: (100 + random.nextInt(1100)).toDouble(), label: "Thu"),
      ChartData(value: (100 + random.nextInt(1100)).toDouble(), label: "Fri"),
      ChartData(value: (100 + random.nextInt(1100)).toDouble(), label: "Sat"),
    ];
  }
}
