import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:financial_management_app/widgets/modal.dart';
import 'package:financial_management_app/widgets/paper_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeCurrency extends StatefulWidget {
  const ChangeCurrency({super.key});

  @override
  State<ChangeCurrency> createState() => _ChangeCurrencyState();
}

class _ChangeCurrencyState extends State<ChangeCurrency> {
  String _selectedOption = 'USD';
  final List<String> _options = ['USD', 'BRL', 'BTC', 'ETH'];

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
              value: _selectedOption,
              underline: const SizedBox(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedOption = value;
                  });
                  // widget.onCurrencyChanged?.call(value);
                }
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
                // TODO: Implement save logic
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
