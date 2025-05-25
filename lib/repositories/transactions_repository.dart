import 'package:financial_management_app/services/user_service.dart';
import 'package:financial_management_app/widgets/bar_chart.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/transaction_model.dart';
import '../services/transactions_service.dart';

class TransactionsRepository {
  final ApiService _apiService;
  final UserService _userService = UserService();

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

  Future<double> getTotalBalance(DateTime date) async {
    List<TransactionModel> todayTransactions = await _apiService
        .getTodaysTransaction(date);

    double totalBalance = todayTransactions.fold(0.0, (sum, transaction) {
      return transaction.type == TransactionType.income
          ? sum + transaction.amount
          : sum - transaction.amount;
    });

    return totalBalance;
  }

  Future<Map<DateTime, int>> getDayBalanceByMonth(DateTime date) async {
    return _apiService.getDayBalanceByMonth(date);
  }

  Future<List<ChartData>> getIncomesByWeek(
    DateTime weekStart,
    DateTime weekEnd,
  ) async {
    return _apiService.getIncomesByWeek(weekStart, weekEnd);
  }

  Future<List<ChartData>> getExpensesByWeek(
    DateTime weekStart,
    DateTime weekEnd,
  ) async {
    return _apiService.getExpensesByWeek(weekStart, weekEnd);
  }
}
