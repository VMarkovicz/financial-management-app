import 'package:financial_management_app/models/transaction_model.dart';
import 'package:financial_management_app/viewmodels/transactions_viewmodel.dart';
import 'package:financial_management_app/viewmodels/user_viewmodel.dart';
import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:financial_management_app/widgets/heatmap_calendar.dart';
import 'package:financial_management_app/widgets/custom_app_bar.dart';
import 'package:financial_management_app/widgets/custom_navigation_bar.dart';
import 'package:financial_management_app/widgets/paper_container.dart';
import 'package:financial_management_app/widgets/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  String? _selectedCurrency;
  DateTime _selectedDate = DateTime.now();
  late TransactionsViewmodel _transactionsViewmodel;
  late UserViewModel _userViewModel;
  List<TransactionModel> _transactionsByDate = [];

  @override
  void initState() {
    super.initState();
    _transactionsViewmodel = context.read<TransactionsViewmodel>();
    _userViewModel = context.read<UserViewModel>();
    _selectedCurrency = _userViewModel.user.defaultCurrency ?? 'USD';
    Future.microtask(
      () => _transactionsViewmodel.getTotalBalanceByDay(_selectedDate),
    );
    Future.microtask(
      () => _transactionsViewmodel.getDayBalanceByMonth(_selectedDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Calendar",
        initialCurrency: _selectedCurrency ?? 'USD',
        onCurrencyChanged: (currency) {
          setState(() {
            _selectedCurrency = currency;
          });
        },
      ),
      bottomNavigationBar: const CustomNavigationBar(currentRoute: '/calendar'),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Consumer<TransactionsViewmodel>(
              builder: (context, viewModel, child) {
                return Column(
                  children: [
                    HeatmapCalendar(
                      key: ValueKey(viewModel.datesHeatmap.hashCode),
                      onClick: (value) {
                        setState(() {
                          _selectedDate = value;
                          _transactionsByDate = [];
                        });
                        viewModel.getTotalBalanceByDay(_selectedDate);
                      },
                      onMonthChange: (monthDate) {
                        viewModel.getDayBalanceByMonth(monthDate);
                      },
                      datesHeatmap: viewModel.datesHeatmap,
                    ),
                    const SizedBox(height: 32),
                    PaperContainer(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 46.0),
                        child: Column(
                          children: [
                            Text(
                              '${DateFormat.yMMMMd().format(_selectedDate)} Balance:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                            viewModel.busy
                                ? const CircularProgressIndicator()
                                : Text(
                                  '${viewModel.totalBalanceByDay} $_selectedCurrency',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      label: 'See Transactions',
                      onPressed: () async {
                        List<TransactionModel> transactions = await viewModel
                            .getTransactionsByDate(_selectedDate);
                        setState(() {
                          _transactionsByDate = transactions;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        spacing: 16,
                        children:
                            _transactionsByDate
                                .map(
                                  (transaction) => TransactionWidget(
                                    id: transaction.id,
                                    name: transaction.name,
                                    description: transaction.description,
                                    amount: transaction.amount,
                                    type: transaction.type,
                                    date: transaction.date,
                                    onDelete: () async {
                                      await viewModel.deleteTransaction(
                                        transaction.id,
                                        (amount) =>
                                            viewModel.getTotalBalanceByDay(
                                              _selectedDate,
                                            ),
                                      );
                                      final transactions = await viewModel
                                          .getTransactionsByDate(_selectedDate);
                                      setState(() {
                                        _transactionsByDate = transactions;
                                      });
                                    },
                                    onEdit: (editedTransaction) async {
                                      await viewModel.updateTransaction(
                                        editedTransaction,
                                      );
                                      final transactions = await viewModel
                                          .getTransactionsByDate(_selectedDate);
                                      await viewModel.getTotalBalanceByDay(
                                        _selectedDate,
                                      );
                                      setState(() {
                                        _transactionsByDate = transactions;
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
