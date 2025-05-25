import 'package:financial_management_app/models/user_model.dart';
import 'package:financial_management_app/viewmodels/user_viewmodel.dart';
import 'package:financial_management_app/views/authentication/login_view.dart';
import 'package:financial_management_app/views/settings/widgets/change_currency.dart';
import 'package:financial_management_app/views/settings/widgets/edit_profile.dart';
import 'package:financial_management_app/views/settings/widgets/profile_avatar.dart';
import 'package:financial_management_app/widgets/custom_app_bar.dart';
import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late UserViewModel _userViewModel;
  late final UserModel _user;

  @override
  void initState() {
    super.initState();
    _userViewModel = context.read<UserViewModel>();
  }

  void _logout() async {
    await _userViewModel.logoutUser();
    Get.off(
      () => const LoginView(),
      preventDuplicates: true,
      transition: Transition.noTransition,
    );
  }

  void _deleteAccount(_user) async {
    await _userViewModel.deleteUser(_user.id);
    Get.off(
      () => const LoginView(),
      preventDuplicates: true,
      transition: Transition.noTransition,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder:
          (context, userViewModel, child) => Scaffold(
            appBar: CustomAppBar(title: "Settings", showActions: false),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ProfileAvatar(
                          // use the userViewModel to get the user data
                          username: userViewModel.user.username,
                          imageUrl: userViewModel.user.profilePictureUrl ?? '',
                        ),
                        const SizedBox(height: 16),
                        EditProfile(user: userViewModel.user),
                        const SizedBox(height: 16),
                        const ChangeCurrency(),
                      ],
                    ),
                    Column(
                      children: [
                        CustomButton(
                          label: "Logout",
                          backgroundColor: ButtonType.ghost,
                          onPressed: () {
                            _logout();
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          label: "Delete Account",
                          backgroundColor: ButtonType.secondary,
                          onPressed: () {
                            _deleteAccount(userViewModel.user);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
