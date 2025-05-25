import 'package:flutter/foundation.dart';

enum TransactionType { income, expense }

class TransactionModel {
  final String id;
  final String name;
  final TransactionType type;
  final double amount;
  final DateTime date;
  final String description;

  TransactionModel({
    required this.id,
    required this.name,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == 'TransactionType.${json['type']}',
        orElse: () => TransactionType.expense,
      ),
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
    };
  }
}

class TransactionCreationModel {
  final String name;
  final TransactionType type;
  final double amount;
  final DateTime date;
  final String description;

  TransactionCreationModel({
    required this.name,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
  });

  factory TransactionCreationModel.fromJson(Map<String, dynamic> json) {
    return TransactionCreationModel(
      name: json['name'] as String,
      type: json['type'] as TransactionType,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.toString().split('.').last,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
    };
  }
}
