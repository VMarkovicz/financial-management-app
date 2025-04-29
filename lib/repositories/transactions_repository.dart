import '../models/transaction_model.dart';
import '../services/api_service.dart';

class TransactionsRepository {
  final ApiService _apiService;

  TransactionsRepository(this._apiService);

  Future<List<Transaction>> getTransactions(String userId) async {
    return _apiService.getTransactions(userId);
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _apiService.addTransaction(transaction);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _apiService.updateTransaction(transaction);
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _apiService.deleteTransaction(transactionId);
  }

  Future<double> getTotalTodayBalance() async {
    DateTime now = DateTime.now();

    List<Transaction> todayTransactions = await _apiService
        .getTodaysTransaction(now);

    double totalBalance = todayTransactions.fold(0.0, (sum, transaction) {
      return sum + transaction.amount;
    });

    return totalBalance;
  }
}
