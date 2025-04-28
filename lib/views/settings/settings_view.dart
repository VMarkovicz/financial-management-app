import 'package:financial_management_app/views/settings/widgets/edit_profile.dart';
import 'package:financial_management_app/views/settings/widgets/change_currency.dart';
import 'package:financial_management_app/views/settings/widgets/profile_avatar.dart';
import 'package:financial_management_app/widgets/custom_app_bar.dart';
import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Settings", showActions: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                spacing: 16,
                children: [ProfileAvatar(), EditProfile(), ChangeCurrency()],
              ),
              Column(
                spacing: 16,
                children: [
                  CustomButton(
                    label: "Logout",
                    backgroundColor: ButtonType.ghost,
                    onPressed: () {},
                  ),
                  CustomButton(
                    label: "Delete Account",
                    backgroundColor: ButtonType.secondary,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
