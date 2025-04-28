import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class Transaction extends StatelessWidget {
  final String title;
  final String description;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String? currency;

  const Transaction({
    super.key,
    required this.title,
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
    this.currency = 'USD',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              type == TransactionType.income
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              color:
                  type == TransactionType.income
                      ? Color(0xFF68E093)
                      : Color(0XFFE0686A),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(description, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
            Text(
              '${currency} ${type == TransactionType.expense ? '-' : '+'}${amount.toStringAsFixed(2)}',
              style: TextStyle(
                color:
                    type == TransactionType.income
                        ? Color(0xFF68E093)
                        : Color(0XFFE0686A),
              ),
            ),
            SizedBox(width: 8),
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.more_vert),
              color: Colors.white,
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    // TODO: Handle edit action
                    break;
                  case 'delete':
                    // TODO: Handle delete action
                    break;
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
            ),
          ],
        ),
      ),
    );
  }
}
