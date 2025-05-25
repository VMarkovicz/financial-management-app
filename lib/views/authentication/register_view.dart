import 'package:financial_management_app/models/user_model.dart';
import 'package:financial_management_app/viewmodels/user_viewmodel.dart';
import 'package:financial_management_app/views/authentication/login_view.dart';
import 'package:financial_management_app/views/home/home_view.dart';
import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:financial_management_app/widgets/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  var uuid = Uuid();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _register(UserViewModel userViewModel) {
    if (_emailController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    try {
      userViewModel.createUser(
        UserRegisterModel(
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Registration failed. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = context.watch<UserViewModel>();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(64.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "FinTrack",
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),

                Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),

                CustomTextField(
                  label: "Email",
                  hint: "Enter your email",
                  controller: _emailController,
                  isEmail: true,
                ),

                CustomTextField(
                  label: "Username",
                  hint: "Enter your username",
                  controller: _usernameController,
                ),

                CustomTextField(
                  label: "Password",
                  hint: "Enter your password",
                  controller: _passwordController,
                  isPassword: true,
                ),

                CustomTextField(
                  label: "Confirm Password",
                  hint: "Confirm your password",
                  controller: _confirmPasswordController,
                  isPassword: true,
                ),

                CustomButton(
                  label: "Sign Up",
                  backgroundColor: ButtonType.primary,
                  onPressed: () => _register(userViewModel),
                  isLoading: userViewModel.busy,
                ),
                RichText(
                  text: TextSpan(
                    text: "Already have an account.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.blue,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(
                              () => const LoginView(),
                              preventDuplicates: true,
                              transition: Transition.noTransition,
                            );
                          },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
