import 'package:financial_management_app/views/authentication/register_view.dart';
import 'package:financial_management_app/views/home/home_view.dart';
import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:financial_management_app/widgets/custom_text_field.dart';
import 'package:flutter/gestures.dart';
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
            spacing: 32,
            children: [
              Text(
                "FinTrack",
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              Text(
                "Sign In",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              CustomTextField(
                label: "Email",
                hint: "Enter your email",
                controller: _emailController,
                isEmail: true,
              ),
              CustomTextField(
                label: "Password",
                hint: "Enter your password",
                controller: _passwordController,
                isPassword: true,
              ),
              CustomButton(
                label: "Sign In",
                backgroundColor: ButtonType.primary,
                onPressed:
                    () => Get.off(
                      () => const HomeView(),
                      preventDuplicates: true,
                      transition: Transition.noTransition,
                    ),
              ),
              Column(
                spacing: 16,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Reset Password.",
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
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.blue,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(
                                    () => RegisterView(),
                                    preventDuplicates: true,
                                    transition: Transition.noTransition,
                                  );
                                },
                        ),
                      ],
                    ),
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
