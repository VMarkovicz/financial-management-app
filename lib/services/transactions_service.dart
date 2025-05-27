import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_management_app/models/transaction_model.dart';
import 'package:financial_management_app/widgets/bar_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ApiService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final random = Random();

  Future<List<TransactionModel>> getTransactions() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    if (userDoc == null) {
      throw Exception('User document not found.');
    }

    try {
      var transactionsSnapshot = await userDoc.collection('transactions').get();
      if (transactionsSnapshot.docs.isEmpty) {
        return [];
      }
      return transactionsSnapshot.docs.map((doc) {
        return TransactionModel.fromJson({
          ...doc.data() as Map<String, dynamic>,
          'id': doc.id,
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<TransactionModel> addTransaction(
    TransactionCreationModel transaction,
  ) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    if (userDoc == null) {
      throw Exception('User document not found.');
    }

    // if the collection does not exist, create it
    var createdTransaction = await userDoc
        .collection('transactions')
        .add(transaction.toJson());

    return TransactionModel(
      id: createdTransaction.id,
      name: transaction.name,
      amount: transaction.amount,
      type: transaction.type,
      date: transaction.date,
      description: transaction.description,
    );
  }

  Future<TransactionModel> updateTransaction(
    TransactionModel transaction,
  ) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    if (userDoc == null) {
      throw Exception('User document not found.');
    }
    await userDoc
        .collection('transactions')
        .doc(transaction.id)
        .update(transaction.toJson());
    return TransactionModel(
      id: transaction.id,
      name: transaction.name,
      amount: transaction.amount,
      type: transaction.type,
      date: transaction.date,
      description: transaction.description,
    );
  }

  Future<void> deleteTransaction(String transactionId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    if (userDoc == null) {
      throw Exception('User document not found.');
    }

    await userDoc.collection('transactions').doc(transactionId).delete();
  }

  Future<double> getTotalMonthlyBalance(DateTime currentDate) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    if (userDoc == null) {
      throw Exception('User document not found.');
    }
    try {
      var transactionsSnapshot =
          await userDoc
              .collection('transactions')
              .where(
                'date',
                isGreaterThanOrEqualTo:
                    DateTime(
                      currentDate.year,
                      currentDate.month,
                      1,
                    ).toIso8601String(),
              )
              .where(
                'date',
                isLessThanOrEqualTo:
                    DateTime(
                      currentDate.year,
                      currentDate.month + 1,
                      0,
                    ).toIso8601String(),
              )
              .aggregate(sum('amount'))
              .get();

      return transactionsSnapshot.getSum('amount') ?? 0.0;
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<double> getTotalBalanceByDay(DateTime currentDate) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    if (userDoc == null) {
      throw Exception('User document not found.');
    }
    try {
      var transactionsSnapshot =
          await userDoc
              .collection('transactions')
              .where(
                'date',
                isGreaterThanOrEqualTo:
                    DateTime(
                      currentDate.year,
                      currentDate.month,
                      currentDate.day,
                    ).toIso8601String(),
              )
              .where(
                'date',
                isLessThanOrEqualTo:
                    DateTime(
                      currentDate.year,
                      currentDate.month,
                      currentDate.day,
                      23,
                      59,
                      59,
                    ).toIso8601String(),
              )
              .aggregate(sum('amount'))
              .get();

      return transactionsSnapshot.getSum('amount') ?? 0.0;
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<List<TransactionModel>> getDayBalanceByMonth(
    DateTime currentDate,
  ) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    if (userDoc == null) {
      throw Exception('User document not found.');
    }
    try {
      var transactionsSnapshot =
          await userDoc
              .collection('transactions')
              .where(
                'date',
                isGreaterThanOrEqualTo:
                    DateTime(
                      currentDate.year,
                      currentDate.month,
                      1,
                    ).toIso8601String(),
              )
              .where(
                'date',
                isLessThanOrEqualTo:
                    DateTime(
                      currentDate.year,
                      currentDate.month + 1,
                      0,
                    ).toIso8601String(),
              )
              .get();

      if (transactionsSnapshot.docs.isEmpty) {
        return [];
      }

      return transactionsSnapshot.docs.map((doc) {
        return TransactionModel.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<List<TransactionModel>> getExpensesByWeek(
    DateTime weekStart,
    DateTime weekEnd,
  ) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    if (userDoc == null) {
      throw Exception('User document not found.');
    }
    try {
      var transactionsSnapshot =
          await userDoc
              .collection('transactions')
              .where(
                'date',
                isGreaterThanOrEqualTo: weekStart.toIso8601String(),
              )
              .where('date', isLessThanOrEqualTo: weekEnd.toIso8601String())
              .where('type', isEqualTo: "expense")
              .get();

      if (transactionsSnapshot.docs.isEmpty) {
        return [];
      }

      return transactionsSnapshot.docs.map((doc) {
        return TransactionModel.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<List<TransactionModel>> getIncomesByWeek(
    DateTime weekStart,
    DateTime weekEnd,
  ) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    if (userDoc == null) {
      throw Exception('User document not found.');
    }
    try {
      var transactionsSnapshot =
          await userDoc
              .collection('transactions')
              .where(
                'date',
                isGreaterThanOrEqualTo: weekStart.toIso8601String(),
              )
              .where('date', isLessThanOrEqualTo: weekEnd.toIso8601String())
              .where('type', isEqualTo: "income")
              .get();

      if (transactionsSnapshot.docs.isEmpty) {
        return [];
      }

      return transactionsSnapshot.docs.map((doc) {
        return TransactionModel.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }
}
