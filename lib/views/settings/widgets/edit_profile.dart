import 'package:financial_management_app/models/user_model.dart';
import 'package:financial_management_app/viewmodels/user_viewmodel.dart';
import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:financial_management_app/widgets/custom_text_field.dart';
import 'package:financial_management_app/widgets/modal.dart';
import 'package:financial_management_app/widgets/paper_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final UserModel user;
  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late UserViewModel _userViewModel;
  final TextEditingController _newUsernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userViewModel = context.read<UserViewModel>();
  }

  @override
  void dispose() {
    _newUsernameController.dispose();
    super.dispose();
  }

  void _updateUser() {
    if (_newUsernameController.value.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }
    try {
      _userViewModel.updateUser(_newUsernameController.text);
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
        // Update controller text when modal opens
        _newUsernameController.text = widget.user.username;

        Modal.show(
          context: context,
          title: "Edit Profile",
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: "Edit Profile",
                hint: "Enter your username",
                controller: _newUsernameController,
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
                _updateUser();
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
