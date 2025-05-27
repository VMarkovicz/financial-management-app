import 'dart:math';

import 'package:financial_management_app/services/user_service.dart';
import 'package:financial_management_app/widgets/bar_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/transaction_model.dart';
import '../services/transactions_service.dart';

class TransactionsRepository {
  final ApiService _apiService;
  final UserService _userService = UserService();
  final random = Random();

  TransactionsRepository(this._apiService);

  Future<List<TransactionModel>> getTransactions() async {
    return _apiService.getTransactions();
  }

  Future<TransactionModel> addTransaction(
    TransactionCreationModel transaction,
  ) async {
    try {
      return await _apiService.addTransaction(transaction);
    } catch (e) {
      throw Exception("Failed to add transaction: $e");
    }
  }

  Future<TransactionModel> updateTransaction(
    TransactionModel transaction,
  ) async {
    return await _apiService.updateTransaction(transaction);
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _apiService.deleteTransaction(transactionId);
  }

  //this is used to get the transactions for the home view
  Future<double> getTotalMonthlyBalance(DateTime date) async {
    return await _apiService.getTotalMonthlyBalance(date);
  }

  // This method is used to get the total balance for a specific day - calendar view
  Future<double> getTotalBalanceByDay(DateTime date) async {
    return await _apiService.getTotalBalanceByDay(date);
  }

  // This method is used to get the balance by day for a specific month - calendar view
  Future<Map<DateTime, double>> getDayBalanceByMonth(DateTime date) async {
    var transactions = _apiService.getDayBalanceByMonth(date);
    Map<DateTime, double> dailyTotals = {};
    for (var transaction in await transactions) {
      DateTime transactionDate = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );
      dailyTotals[transactionDate] =
          (dailyTotals[transactionDate] ?? 0.0) + transaction.amount;
    }
    return dailyTotals;
  }

  Future<List<ChartData>> getIncomesByWeek(
    DateTime weekStart,
    DateTime weekEnd,
  ) async {
    var transactions = await _apiService.getIncomesByWeek(weekStart, weekEnd);

    Map<String, double> dailyTotals = _defaultDailyTotals();

    for (var transaction in transactions) {
      String dayLabel = _getDayLabel(transaction.date.weekday);
      dailyTotals[dayLabel] =
          (dailyTotals[dayLabel] ?? 0.0) + transaction.amount;
    }

    return dailyTotals.entries.map((entry) {
      return ChartData(value: entry.value, label: entry.key);
    }).toList();
  }

  Future<List<ChartData>> getExpensesByWeek(
    DateTime weekStart,
    DateTime weekEnd,
  ) async {
    var transactions = await _apiService.getExpensesByWeek(weekStart, weekEnd);

    Map<String, double> dailyTotals = _defaultDailyTotals();

    for (var transaction in transactions) {
      String dayLabel = _getDayLabel(transaction.date.weekday);
      dailyTotals[dayLabel] =
          (dailyTotals[dayLabel] ?? 0.0) + transaction.amount.abs();
    }

    return dailyTotals.entries.map((entry) {
      return ChartData(value: entry.value, label: entry.key);
    }).toList();
  }

  Map<String, double> _defaultDailyTotals() {
    return {
      'Sun': 0.0,
      'Mon': 0.0,
      'Tue': 0.0,
      'Wed': 0.0,
      'Thu': 0.0,
      'Fri': 0.0,
      'Sat': 0.0,
    };
  }

  String _getDayLabel(int weekday) {
    switch (weekday) {
      case DateTime.sunday:
        return 'Sun';
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      default:
        return '';
    }
  }
}
