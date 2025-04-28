import 'package:financial_management_app/views/authentication/login_view.dart';
import 'package:financial_management_app/views/home/home_view.dart';
import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:financial_management_app/widgets/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
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
                label: "Sign Un",
                backgroundColor: ButtonType.primary,
                onPressed:
                    () => Get.off(
                      () => const HomeView(),
                      preventDuplicates: true,
                      transition: Transition.noTransition,
                    ),
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
                            () => const HomeView(),
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
    );
  }
}
