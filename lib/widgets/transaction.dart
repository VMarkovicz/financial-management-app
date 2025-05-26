import 'package:financial_management_app/models/transaction_model.dart';
import 'package:financial_management_app/theme/app_theme.dart';
import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:financial_management_app/widgets/custom_text_field.dart';
import 'package:financial_management_app/widgets/modal.dart';
import 'package:flutter/material.dart';

class TransactionWidget extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String? currency;
  final VoidCallback? onDelete;
  final Function(TransactionModel)? onEdit; // Changed to TransactionModel

  const TransactionWidget({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
    this.currency = 'USD',
    this.onDelete,
    this.onEdit,
  });

  void _handleEdit(BuildContext context) {
    final nameController = TextEditingController(text: name);
    final descriptionController = TextEditingController(text: description);
    final amountController = TextEditingController(text: amount.toString());
    TransactionType currentType = type;

    Modal.show(
      context: context,
      title: 'Edit Transaction',
      body: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'Name',
                hint: 'Enter name',
                controller: nameController,
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
              const SizedBox(height: 16),
              DropdownButtonFormField<TransactionType>(
                value: currentType,
                items: [
                  DropdownMenuItem(
                    value: TransactionType.income,
                    child: Text('Income'),
                  ),
                  DropdownMenuItem(
                    value: TransactionType.expense,
                    child: Text('Expense'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => currentType = value);
                  }
                },
              ),
            ],
          );
        },
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
            if (nameController.text.isEmpty || amountController.text.isEmpty) {
              return;
            }

            final newTransaction = TransactionModel(
              id: id,
              name: nameController.text,
              description: descriptionController.text,
              amount: double.tryParse(amountController.text) ?? amount,
              type: currentType,
              date: date,
            );

            onEdit?.call(newTransaction);
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
        color: AppTheme.surfaceLight,
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
                      ? AppTheme.success
                      : AppTheme.error,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(description, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
            Text(
              '${currency} ${type == TransactionType.expense ? '' : '+'}${amount.toStringAsFixed(2)}',
              style: TextStyle(
                color:
                    type == TransactionType.income
                        ? AppTheme.success
                        : AppTheme.error,
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
                    if (onDelete != null) {
                      onDelete?.call();
                    }
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
