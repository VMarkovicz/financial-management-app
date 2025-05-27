import 'package:financial_management_app/viewmodels/transactions_viewmodel.dart';
import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:financial_management_app/widgets/heatmap_calendar.dart';
import 'package:financial_management_app/widgets/custom_app_bar.dart';
import 'package:financial_management_app/widgets/custom_navigation_bar.dart';
import 'package:financial_management_app/widgets/paper_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  String _selectedCurrency = 'USD';
  DateTime _selectedDate = DateTime.now();
  late TransactionsViewmodel _transactionsViewmodel;

  @override
  void initState() {
    super.initState();
    _transactionsViewmodel = context.read<TransactionsViewmodel>();
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
        initialCurrency: _selectedCurrency,
        onCurrencyChanged: (currency) {
          setState(() {
            _selectedCurrency = currency;
          });
        },
      ),
      bottomNavigationBar: const CustomNavigationBar(currentRoute: '/calendar'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            spacing: 32,
            children: [
              Consumer<TransactionsViewmodel>(
                builder: (context, viewModel, child) {
                  return HeatmapCalendar(
                    key: ValueKey(viewModel.datesHeatmap.hashCode),
                    onClick: (value) {
                      setState(() {
                        _selectedDate = value;
                      });
                      viewModel.getTotalBalanceByDay(_selectedDate);
                    },
                    onMonthChange: (monthDate) {
                      viewModel.getDayBalanceByMonth(monthDate);
                    },
                    datesHeatmap: viewModel.datesHeatmap,
                  );
                },
              ),
              PaperContainer(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 46.0),
                  child: Column(
                    spacing: 16,
                    children: [
                      Text(
                        '${DateFormat.yMMMMd().format(_selectedDate)} Balance:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Consumer<TransactionsViewmodel>(
                        builder: (context, viewModel, child) {
                          if (viewModel.busy) {
                            return const CircularProgressIndicator();
                          }
                          return Text(
                            '${viewModel.totalBalanceByDay} $_selectedCurrency',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              CustomButton(label: 'See Transactions', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
