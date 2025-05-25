import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_management_app/models/transaction_model.dart';
import 'package:financial_management_app/services/user_service.dart';
import 'package:financial_management_app/widgets/bar_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/user_model.dart';

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
    debugPrint('Updating transaction: ${transaction.id}');
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

  Future<List<TransactionModel>> getTodaysTransaction(
    DateTime currentDate,
  ) async {
    return [];
  }

  Future<Map<DateTime, int>> getDayBalanceByMonth(DateTime date) async {
    await Future.delayed(Duration(seconds: 1));
    /*     if (date.month == 4) {
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
    } */

    return {};
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
