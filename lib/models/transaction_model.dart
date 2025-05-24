enum TransactionType { income, expense }

class TransactionModel {
  final String id;
  final String name;
  final TransactionType type;
  final double amount;
  final DateTime date;
  final String description;
  final String userId;

  TransactionModel({
    required this.id,
    required this.name,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
    required this.userId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as TransactionType,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String,
      userId: json['userId'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'userId': userId,
    };
  }
}
