import 'package:financial_management_app/views/calendar/calendar_view.dart';
import 'package:financial_management_app/widgets/custom_app_bar.dart';
import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:financial_management_app/widgets/custom_text_field.dart';
import 'package:financial_management_app/widgets/paper_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final TextEditingController _testController = TextEditingController();
  String _selectedCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Settings",
        initialCurrency: _selectedCurrency,
        showActions: false,
        onCurrencyChanged: (currency) {
          setState(() {
            _selectedCurrency = currency;
          });
        },
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: PaperContainer(
            width: double.infinity,
            height: 100,
            child: Text('Hello!'),
          ),
        ),
      ),
    );
  }
}
