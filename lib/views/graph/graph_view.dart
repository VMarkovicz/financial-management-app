import 'package:financial_management_app/widgets/bar_chart.dart';
import 'package:financial_management_app/widgets/custom_app_bar.dart';
import 'package:financial_management_app/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GraphView extends StatefulWidget {
  const GraphView({super.key});

  @override
  State<GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  String _selectedCurrency = 'USD';
  DateTime _selectedDate = DateTime.now();

  void _selectWeek(bool next) {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day + (next ? 7 : -7),
      );
    });
  }

  String _getWeekRange() {
    // Get the start of the week (Monday)
    DateTime startOfWeek = _selectedDate.subtract(
      Duration(days: _selectedDate.weekday - 1),
    );
    // Get the end of the week (Sunday)
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    // If start and end are in the same month
    if (startOfWeek.month == endOfWeek.month) {
      return "${DateFormat('MMM d').format(startOfWeek)} - ${DateFormat('d, y').format(endOfWeek)}";
    }
    // If they're in different months
    return "${DateFormat('MMM d').format(startOfWeek)} - ${DateFormat('MMM d, y').format(endOfWeek)}";
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
        child: Column(
          spacing: 32,
          children: [
            const Text(
              "Weekly Overview",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Incomes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w100),
                ),
              ],
            ),
            BarChart(
              barColor: const Color(0xFF68E093),
              data: [
                ChartData(value: 300, label: "Jan"),
                ChartData(value: 200, label: "Feb"),
                ChartData(value: 100, label: "Mar"),
                ChartData(value: 500, label: "Apr"),
                ChartData(value: 200, label: "May"),
                ChartData(value: 1200, label: "Jun"),
                ChartData(value: 300, label: "Jul"),
                ChartData(value: 600, label: "Aug"),
                ChartData(value: 900, label: "Sep"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Expenses",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w100),
                ),
              ],
            ),
            BarChart(
              barColor: const Color(0XFFE0686A),
              data: [
                ChartData(value: 300, label: "Jan"),
                ChartData(value: 200, label: "Feb"),
                ChartData(value: 100, label: "Mar"),
                ChartData(value: 500, label: "Apr"),
                ChartData(value: 200, label: "May"),
                ChartData(value: 1200, label: "Jun"),
                ChartData(value: 300, label: "Jul"),
                ChartData(value: 600, label: "Aug"),
                ChartData(value: 900, label: "Sep"),
              ],
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
