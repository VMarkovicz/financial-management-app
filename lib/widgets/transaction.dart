import 'package:flutter/material.dart';
import 'package:financial_management_app/widgets/modal.dart';
import 'package:financial_management_app/widgets/custom_text_field.dart';
import 'package:financial_management_app/widgets/custom_button.dart';

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

  void _handleEdit(BuildContext context) {
    final titleController = TextEditingController(text: title);
    final descriptionController = TextEditingController(text: description);
    final amountController = TextEditingController(text: amount.toString());

    Modal.show(
      context: context,
      title: 'Edit Transaction',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            label: 'Title',
            hint: 'Enter title',
            controller: titleController,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Description',
            hint: 'Enter description',
            controller: descriptionController,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Amount',
            hint: 'Enter amount',
            controller: amountController,
          ),
        ],
      ),
      actions: [
        CustomButton(
          label: 'Cancel',
          backgroundColor: ButtonType.ghost,
          onPressed: () => Navigator.of(context).pop(),
        ),
        CustomButton(
          label: 'Save',
          width: 100,
          onPressed: () {
            // TODO: Implement save logic
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

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
                    _handleEdit(context);
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
