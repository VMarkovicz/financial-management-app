import 'package:financial_management_app/widgets/bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/transaction_model.dart';
import '../repositories/transactions_repository.dart';

class TransactionsViewmodel extends ChangeNotifier {
  final TransactionsRepository _transactionsRepository;

  TransactionsViewmodel(this._transactionsRepository);

  List<TransactionModel> transactions = [];
  Map<DateTime, double> balanceByDay = {};
  Map<DateTime, int> datesHeatmap = {};
  double totalMonthlyBalance = 0.0;
  double totalBalanceByDay = 0.0;
  bool busy = false;
  bool busyForCalendar = false;

  Future<void> loadTransactions() async {
    busy = true;
    notifyListeners();
    try {
      transactions = await _transactionsRepository.getTransactionsByDate(
        DateTime.now(),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to load transactions: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      transactions = [];
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(
    TransactionCreationModel transaction,
    Future<void> Function(double) updateBalance,
  ) async {
    busy = true;
    notifyListeners();
    try {
      var newTransaction = await _transactionsRepository.addTransaction(
        transaction,
      );
      balanceByDay = await _transactionsRepository.getDayBalanceByMonth(
        newTransaction.date,
      );
      var newTransactionDailyBalance = balanceByDay[newTransaction.date] ?? 0;
      datesHeatmap[newTransaction.date] =
          (newTransactionDailyBalance + newTransaction.amount) > 0 ? 1 : 2;

      var newHeatmap = Map<DateTime, int>.from(datesHeatmap);

      datesHeatmap = newHeatmap;
      transactions.add(newTransaction);
      await updateBalance(transaction.amount);
      totalMonthlyBalance += newTransaction.amount;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to add transaction: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    busy = true;
    notifyListeners();
    var updatedTransaction = await _transactionsRepository.updateTransaction(
      transaction,
    );
    transactions =
        transactions.map((t) {
          return t.id == updatedTransaction.id ? updatedTransaction : t;
        }).toList();
    busy = false;
    notifyListeners();
  }

  Future<void> deleteTransaction(
    String transactionId,
    Future<void> Function(double) updateBalance,
  ) async {
    busy = true;
    notifyListeners();
    await _transactionsRepository.deleteTransaction(transactionId);
    var deletedTransaction = transactions.firstWhere(
      (t) => t.id == transactionId,
      orElse:
          () => TransactionModel(
            id: '',
            name: '',
            amount: 0,
            type: TransactionType.income,
            date: DateTime.now(),
            description: '',
          ),
    );
    if (deletedTransaction.id.isNotEmpty) {
      transactions.removeWhere((t) => t.id == transactionId);
      await updateBalance(
        deletedTransaction.type == TransactionType.income
            ? -deletedTransaction.amount
            : deletedTransaction.amount,
      );
      totalMonthlyBalance +=
          deletedTransaction.type == TransactionType.income
              ? -deletedTransaction.amount
              : deletedTransaction.amount;
    }
    await loadTransactions();
    busy = false;
    notifyListeners();
  }

  // This method is used to get the transactions for the home view
  Future<void> getTotalMonthlyBalance() async {
    busy = true;
    notifyListeners();
    DateTime today = DateTime.now();
    totalMonthlyBalance = await _transactionsRepository.getTotalMonthlyBalance(
      today,
    );
    busy = false;
    notifyListeners();
  }

  // This method is used to get the total balance for a specific day - calendar view
  Future<void> getTotalBalanceByDay(DateTime date) async {
    busy = true;
    notifyListeners();
    totalBalanceByDay = await _transactionsRepository.getTotalBalanceByDay(
      date,
    );
    busy = false;
    notifyListeners();
  }

  // This method is used to get the balance by day for a specific month - calendar view
  Future<void> getDayBalanceByMonth(DateTime date) async {
    busyForCalendar = true;
    notifyListeners();
    if (balanceByDay.isNotEmpty &&
        balanceByDay.keys.first.month == date.month &&
        balanceByDay.keys.first.year == date.year) {
      busyForCalendar = false;
      notifyListeners();
      return;
    }
    balanceByDay = await _transactionsRepository.getDayBalanceByMonth(date);

    for (var entry in balanceByDay.entries) {
      datesHeatmap[DateTime(entry.key.year, entry.key.month, entry.key.day)] =
          (entry.value > 0 ? 1 : 2);
    }

    busyForCalendar = false;
    notifyListeners();
  }

  Future<List<ChartData>> getExpensesByWeek(
    DateTime weekStart,
    DateTime weekEnd,
  ) async {
    busy = true;
    notifyListeners();
    List<ChartData> expenses = await _transactionsRepository.getExpensesByWeek(
      weekStart,
      weekEnd,
    );

    busy = false;
    notifyListeners();
    return expenses;
  }

  Future<List<TransactionModel>> getTransactionsByDate(DateTime date) async {
    busy = true;
    notifyListeners();
    List<TransactionModel> transactionsByDay = await _transactionsRepository
        .getTransactionsByDate(date);
    busy = false;
    notifyListeners();
    return transactionsByDay;
  }

  Future<List<ChartData>> getIncomeByWeek(
    DateTime weekStart,
    DateTime weekEnd,
  ) async {
    busy = true;
    notifyListeners();
    List<ChartData> incomes = await _transactionsRepository.getIncomesByWeek(
      weekStart,
      weekEnd,
    );
    busy = false;
    notifyListeners();
    return incomes;
  }
}
