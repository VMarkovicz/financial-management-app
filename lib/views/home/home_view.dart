import 'package:financial_management_app/views/calendar/calendar_view.dart';
import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomButton(
        label: "teste",
        onPressed: () {
          Get.to(() => const CalendarView());
        },
      ),
    );
  }
}
