import 'package:financial_management_app/models/user_model.dart';
import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:financial_management_app/widgets/custom_text_field.dart';
import 'package:financial_management_app/widgets/modal.dart';
import 'package:financial_management_app/widgets/paper_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfile extends StatefulWidget {
  final User user;
  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _testController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _testController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Update controller text when modal opens
        _testController.text = widget.user.username ?? '';

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
