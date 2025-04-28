import 'package:financial_management_app/widgets/custom_app_bar.dart';
import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:financial_management_app/widgets/custom_text_field.dart';
import 'package:financial_management_app/widgets/modal.dart';
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
  final List<String> _options = ['USD', 'BRL', 'BTC', 'ETH'];
  // String _selectedOption = widget.initialCurrency;
  String _selectedOption = 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Settings", showActions: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              PaperContainer(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey.shade200,
                            child: Icon(
                              Icons.person,
                              size: 60,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.greenAccent,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Username",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]
                  ),
                ),
              ),      
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Modal.show(
                    context: context,
                    title: "Edit Profile",
                    body: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextField(
                          label: "Edit Profile",
                          hint: "Enter your username",
                          controller: _testController,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: "Password",
                          hint: "Enter your password",
                          controller: _testController,
                          isEmail: true,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: "Confirm Password",
                          hint: "Confirm your password",
                          controller: _testController,
                          isEmail: true,
                        ),
                      ],
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
                      "Profile",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Modal.show(
                    context: context,
                    title: "Change Currency",
                    body: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color:Color(0xFFF8F8F8), 
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
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
                                  (opt) => DropdownMenuItem(
                                    value: opt,
                                    child: Text(opt),
                                  ),
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              CustomButton(
                label: "Logout",
                backgroundColor: ButtonType.ghost,
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              CustomButton(
                label: "Delete Account",
                backgroundColor: ButtonType.secondary,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
