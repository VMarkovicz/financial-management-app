import 'package:financial_management_app/models/transaction_model.dart';
import 'package:financial_management_app/theme/app_theme.dart';
import 'package:financial_management_app/viewmodels/transactions_viewmodel.dart';
import 'package:financial_management_app/viewmodels/user_viewmodel.dart';
import 'package:financial_management_app/widgets/custom_app_bar.dart';
import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:financial_management_app/widgets/custom_navigation_bar.dart';
import 'package:financial_management_app/widgets/custom_text_field.dart';
import 'package:financial_management_app/widgets/modal.dart';
import 'package:financial_management_app/widgets/paper_container.dart';
import 'package:financial_management_app/widgets/transaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? _selectedCurrency;
  late TransactionsViewmodel _transactionsViewmodel;
  late UserViewModel _userViewModel;
  TransactionType _currentType = TransactionType.income;

  var uuid = Uuid();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _transactionsViewmodel = context.read<TransactionsViewmodel>();
    _userViewModel = context.read<UserViewModel>();
    Future.microtask(() => _transactionsViewmodel.loadTransactions());
    Future.microtask(() => _transactionsViewmodel.getTotalMonthlyBalance());
    _selectedCurrency = _userViewModel.user.defaultCurrency ?? 'USD';
  }

  void _createTransaction() {
    if (nameController.text.isEmpty || amountController.text.isEmpty) {
      Modal.show(
        context: context,
        title: 'Error',
        body: const Text('Please fill in all fields'),
        actions: [
          CustomButton(
            label: 'OK',
            onPressed: () => Get.back(closeOverlays: true),
          ),
        ],
      );
      return;
    }

    final transaction = TransactionCreationModel(
      name: nameController.text,
      description: descriptionController.text,
      amount:
          _currentType == TransactionType.income
              ? double.parse(amountController.text)
              : -double.parse(amountController.text),
      type: _currentType,
      date: DateTime.now(),
    );

    _transactionsViewmodel.addTransaction(
      transaction,
      _userViewModel.updateBalance,
    );

    nameController.clear();
    descriptionController.clear();
    amountController.clear();

    Get.back(closeOverlays: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Home",
        initialCurrency: _selectedCurrency ?? 'USD',
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
            body: Center(
              child: SingleChildScrollView(
                child: Column(
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
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<TransactionType>(
                      value: _currentType,
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
                          setState(() => _currentType = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              CustomButton(
                label: 'Cancel',
                backgroundColor: ButtonType.ghost,
                onPressed: () => Get.back(closeOverlays: true),
              ),
              CustomButton(
                label: 'Save',
                width: 100,
                onPressed: _createTransaction,
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
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 46.0),
                child: Column(
                  children: [
                    Consumer<UserViewModel>(
                      builder: (context, viewModel, child) {
                        if (viewModel.busy) {
                          return const Center(
                            child: Column(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                              ],
                            ),
                          );
                        }

                        return Text(
                          "${_transactionsViewmodel.totalMonthlyBalance} $_selectedCurrency",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        );
                      },
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
                child: Consumer<TransactionsViewmodel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.busy) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView.separated(
                      itemCount: viewModel.transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = viewModel.transactions[index];
                        return TransactionWidget(
                          id: transaction.id,
                          name: transaction.name,
                          description: transaction.description,
                          amount: transaction.amount,
                          date: transaction.date,
                          currency: _selectedCurrency,
                          type: transaction.type,
                          onDelete: () {
                            viewModel.deleteTransaction(
                              transaction.id,
                              _userViewModel.updateBalance,
                            );
                          },
                          onEdit: (newTransaction) {
                            viewModel.updateTransaction(newTransaction);
                          },
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
