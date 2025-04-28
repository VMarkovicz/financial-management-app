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
          ],
        ),
      ),
    );
  }
}
