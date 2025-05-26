import 'package:financial_management_app/viewmodels/user_viewmodel.dart';
import 'package:financial_management_app/views/authentication/register_view.dart';
import 'package:financial_management_app/views/home/home_view.dart';
import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:financial_management_app/widgets/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    final userViewModel = context.read<UserViewModel>();
    // if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
    //   Get.snackbar(
    //     "Error",
    //     "Please fill in all fields",
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    //   return;
    // }
    try {
      var user = await userViewModel.loginUser(
        // _emailController.text,
        // _passwordController.text,
        "markovicz@gmail.com",
        "markovicz",
      );
      Fluttertoast.showToast(
        msg: "Welcome back, ${user.username}!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      Get.off(
        () => const HomeView(),
        preventDuplicates: true,
        transition: Transition.noTransition,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Login failed. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = context.watch<UserViewModel>();
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
                onPressed: () => _login(),
                isLoading: userViewModel.busy,
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
