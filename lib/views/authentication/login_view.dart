import 'package:financial_management_app/views/authentication/register_view.dart';
import 'package:financial_management_app/views/home/home_view.dart';
import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:financial_management_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "FinTrack",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                label: "Email", 
                hint: "Enter your email",
                controller: _emailController,
                isEmail: true,
              ),
              const SizedBox(height: 26),
              CustomTextField(
                label: "Password",
                hint: "Enter your password",
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 50),
              CustomButton(
                label: "Sign In",
                backgroundColor: ButtonType.primary, 
                onPressed: () => Get.off(() => const HomeView()),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => {}, 
                child: Text(
                  "Forgot Password.",
                  style: TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.normal
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Get.off(() => RegisterView()),
                child: Text(
                  "Don't have an account.",
                  style: TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.normal
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}