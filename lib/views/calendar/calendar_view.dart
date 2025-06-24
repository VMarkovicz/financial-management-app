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
  Map<DateTime, int> _datesHeatmap = {};

  @override
  void initState() {
    super.initState();
    _transactionsViewmodel = context.read<TransactionsViewmodel>();
    _userViewModel = context.read<UserViewModel>();
    _selectedCurrency = _userViewModel.user.defaultCurrency;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  void loadData() async {
    await _transactionsViewmodel.getTotalBalanceByDay(_selectedDate);
    await _transactionsViewmodel.getDayBalanceByMonth(_selectedDate);
    if (mounted) {
      setState(() {});
    }
    _datesHeatmap = _transactionsViewmodel.datesHeatmap;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TransactionsViewmodel>();
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
            child: Column(
              children: [
                HeatmapCalendar(
                  key: ValueKey(viewModel.datesHeatmap.hashCode),
                  onClick: (value) {
                    setState(() {
                      _selectedDate = value;
                      _transactionsByDate = [];
                    });
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      viewModel.getTotalBalanceByDay(_selectedDate);
                    });
                  },

                  onMonthChange: (monthDate) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      viewModel.getDayBalanceByMonth(monthDate);
                    });
                  },
                  datesHeatmap: _datesHeatmap,
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
                            : Consumer<UserViewModel>(
                              builder: (context, userViewModel, child) => Text(
                                '${viewModel.totalBalanceByDay} ${_userViewModel.user.defaultCurrency}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                ),
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
                    // Use post frame callback to ensure this doesn't happen during build
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      List<TransactionModel> transactions = await viewModel
                          .getTransactionsByDate(_selectedDate);
                      if (mounted) {
                        setState(() {
                          _transactionsByDate = transactions;
                        });
                      }
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
                                currency: _userViewModel.user.defaultCurrency,
                                onDelete: () async {
                                  // Use post frame callback to avoid setState during build
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) async {
                                    await viewModel.deleteTransaction(
                                      transaction.id,
                                      (amount) => viewModel
                                          .getTotalBalanceByDay(_selectedDate),
                                    );
                                    final transactions = await viewModel
                                        .getTransactionsByDate(_selectedDate);
                                    if (mounted) {
                                      setState(() {
                                        _transactionsByDate = transactions;
                                      });
                                    }
                                  });
                                },
                                onEdit: (editedTransaction) async {
                                  // Use post frame callback to avoid setState during build
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) async {
                                    await viewModel.updateTransaction(
                                      editedTransaction,
                                    );
                                    final transactions = await viewModel
                                        .getTransactionsByDate(_selectedDate);
                                    await viewModel.getTotalBalanceByDay(
                                      _selectedDate,
                                    );
                                    if (mounted) {
                                      setState(() {
                                        _transactionsByDate = transactions;
                                      });
                                    }
                                  });
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
