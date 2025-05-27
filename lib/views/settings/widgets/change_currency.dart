import 'package:financial_management_app/models/user_model.dart';
import 'package:financial_management_app/viewmodels/user_viewmodel.dart';
import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:financial_management_app/widgets/modal.dart';
import 'package:financial_management_app/widgets/paper_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ChangeCurrency extends StatefulWidget {
  final UserModel user;
  const ChangeCurrency({super.key, required this.user});

  @override
  State<ChangeCurrency> createState() => _ChangeCurrencyState();
}

class _ChangeCurrencyState extends State<ChangeCurrency> {
  late UserViewModel _userViewModel;
  String? _selectedCurrency;
  final List<String> _options = ['USD', 'BRL', 'BTC', 'ETH'];

  @override
  void initState() {
    super.initState();
    _userViewModel = context.read<UserViewModel>();
    _selectedCurrency = widget.user.defaultCurrency;
  }

  void _updateCurrency() {
    if (_selectedCurrency == null || _selectedCurrency!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a currency')));
      return;
    }
    try {
      _userViewModel.updateDefaultCurrency(_selectedCurrency!);
      Get.back(closeOverlays: true);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Update failed. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Modal.show(
          context: context,
          title: "Change Currency",
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(30),
            ),
            child: DropdownButton<String>(
              value: _selectedCurrency,
              underline: const SizedBox(),
              onChanged: (currency) {
                setState(() {
                  _selectedCurrency = currency;
                });
              },
              items:
                  _options
                      .map(
                        (opt) => DropdownMenuItem(value: opt, child: Text(opt)),
                      )
                      .toList(),
            ),
          ),
          actions: [
            CustomButton(
              label: 'Cancel',
              backgroundColor: ButtonType.ghost,
              onPressed: () {
                Get.back();
              },
            ),
            CustomButton(
              label: 'Save',
              width: 100,
              onPressed: () {
                _updateCurrency();
                Get.back();
              },
            ),
          ],
        );
      },
      child: PaperContainer(
        alignment: Alignment.centerLeft,
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Default Currency",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
