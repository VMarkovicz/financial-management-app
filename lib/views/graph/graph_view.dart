import 'package:financial_management_app/viewmodels/transactions_viewmodel.dart';
import 'package:financial_management_app/widgets/bar_chart.dart';
import 'package:financial_management_app/widgets/custom_app_bar.dart';
import 'package:financial_management_app/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GraphView extends StatefulWidget {
  const GraphView({super.key});

  @override
  State<GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  String _selectedCurrency = 'USD';
  DateTime _selectedDate = DateTime.now();
  late TransactionsViewmodel _transactionsViewmodel;
  List<ChartData> _incomes = [];
  List<ChartData> _expenses = [];
  late DateTime _startOfWeek;
  late DateTime _endOfWeek;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _transactionsViewmodel = context.read<TransactionsViewmodel>();
    _updateWeekRange();
    Future.microtask(() => _fetchData());
  }

  void _updateWeekRange() {
    _startOfWeek = _selectedDate.subtract(
      Duration(days: _selectedDate.weekday),
    );
    // 
    debugPrint("Start of week: $_startOfWeek.weekday");
    debugPrint(_startOfWeek.weekday.toString());
    _endOfWeek = _startOfWeek.add(const Duration(days: 6));
  }

  Future<void> _fetchData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final incomes = await _transactionsViewmodel.getIncomeByWeek(
        _startOfWeek,
        _endOfWeek,
      );
      final expenses = await _transactionsViewmodel.getExpensesByWeek(
        _startOfWeek,
        _endOfWeek,
      );

      if (!mounted) return;

      setState(() {
        _incomes = incomes;
        _expenses = expenses;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _selectWeek(bool next) {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day + (next ? 7 : -7),
      );
      _updateWeekRange();
    });
    _fetchData();
  }

  String _getWeekRange() {
    if (_startOfWeek.month == _endOfWeek.month) {
      return "${DateFormat('MMM d').format(_startOfWeek)} - ${DateFormat('d, y').format(_endOfWeek)}";
    }
    return "${DateFormat('MMM d').format(_startOfWeek)} - ${DateFormat('MMM d, y').format(_endOfWeek)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Graph",
        initialCurrency: _selectedCurrency,
        onCurrencyChanged: (currency) {
          setState(() {
            _selectedCurrency = currency;
          });
        },
      ),
      bottomNavigationBar: const CustomNavigationBar(currentRoute: '/graph'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  spacing: 32,
                  children: [
                    const Text(
                      "Weekly Overview",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Incomes",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          _getWeekRange(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),
                    BarChart(barColor: const Color(0xFF68E093), data: _incomes),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Expenses",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          _getWeekRange(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),
                    BarChart(
                      barColor: const Color(0XFFE0686A),
                      data: _expenses,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => _selectWeek(false),
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Text(
                          _getWeekRange(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _selectWeek(true),
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }
}
