import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../repositories/transactions_repository.dart';

class TransactionsViewmodel extends ChangeNotifier {
  final TransactionsRepository _transactionsRepository;
  String? _currentUserId;

  TransactionsViewmodel(this._transactionsRepository);

  List<Transaction> transactions = [];
  double totalBalance = 0.0;
  bool busy = false;

  Future<void> loadTransactions(String userId) async {
    _currentUserId = userId;
    busy = true;
    notifyListeners();
    transactions = await _transactionsRepository.getTransactions(userId);
    busy = false;
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    busy = true;
    notifyListeners();
    await _transactionsRepository.addTransaction(transaction);
    await loadTransactions(transaction.userId);
    await getTotalTodayBalance();
    busy = false;
    notifyListeners();
  }

  Future<void> updateTransaction(Transaction transaction) async {
    busy = true;
    notifyListeners();
    await _transactionsRepository.updateTransaction(transaction);
    await loadTransactions(transaction.userId);
    busy = false;
    notifyListeners();
  }

  Future<void> deleteTransaction(String transactionId) async {
    if (_currentUserId == null) return;

    busy = true;
    notifyListeners();
    await _transactionsRepository.deleteTransaction(transactionId);
    await loadTransactions(_currentUserId!);
    await getTotalTodayBalance();
    busy = false;
    notifyListeners();
  }

  Future<void> getTotalTodayBalance() async {
    busy = true;
    notifyListeners();
    totalBalance = await _transactionsRepository.getTotalTodayBalance();
    busy = false;
    notifyListeners();
  }
}
