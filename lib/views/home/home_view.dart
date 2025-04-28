import 'dart:math';

import 'package:financial_management_app/widgets/custom_app_bar.dart';
import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:financial_management_app/widgets/custom_navigation_bar.dart';
import 'package:financial_management_app/widgets/custom_text_field.dart';
import 'package:financial_management_app/widgets/modal.dart';
import 'package:financial_management_app/widgets/paper_container.dart';
import 'package:financial_management_app/widgets/transaction.dart';
import 'package:flutter/material.dart';
import 'package:financial_management_app/theme/app_theme.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _selectedCurrency = 'USD';

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Home",
        initialCurrency: _selectedCurrency,
        showNavigation: false,
        onCurrencyChanged: (currency) {
          setState(() {
            _selectedCurrency = currency;
          });
        },
      ),
      bottomNavigationBar: const CustomNavigationBar(currentRoute: '/home'),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          Modal.show(
            context: context,
            title: 'Create Transaction',
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
        },
        backgroundColor: AppTheme.success,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            PaperContainer(
              width: double.infinity,
              // add a padding only to top and bottom
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 46.0),
                child: Column(
                  children: [
                    Text(
                      "\$1000.00",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "Current Balance",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Text(
              "Today's Usage",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            Expanded(
              child: ClipRect(
                child: ListView.separated(
                  itemCount: 10, // number of transactions
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 16),
                  itemBuilder:
                      (context, index) => Transaction(
                        title: 'Groceries',
                        description: 'blalblalb',
                        amount: 1000,
                        type:
                            Random().nextBool()
                                ? TransactionType.income
                                : TransactionType.expense,
                        date: DateTime.now(),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
