import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:financial_management_app/widgets/custom_text_field.dart';
import 'package:financial_management_app/widgets/modal.dart';
import 'package:financial_management_app/widgets/paper_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _testController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
