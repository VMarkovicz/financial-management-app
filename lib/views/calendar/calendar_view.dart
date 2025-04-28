import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:financial_management_app/widgets/heatmap_calendar.dart';
import 'package:financial_management_app/widgets/custom_app_bar.dart';
import 'package:financial_management_app/widgets/custom_navigation_bar.dart';
import 'package:financial_management_app/widgets/paper_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  String _selectedCurrency = 'USD';
  DateTime _selectedDate = DateTime.now();

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
              HeatmapCalendar(
                onClick: (value) {
                  setState(() {
                    _selectedDate = value;
                  });
                },
              ),
              PaperContainer(
                width: double.infinity,
                // add a padding only to top and bottom
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
                      Text(
                        "\$1000.00",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
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
