import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financial_management_app/views/home/home_view.dart';
import 'package:financial_management_app/views/calendar/calendar_view.dart';
import 'package:financial_management_app/views/graph/graph_view.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key, required this.currentRoute});

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavItem(
              icon: Icons.home,
              label: 'Home',
              isSelected: currentRoute == '/home',
              onTap:
                  () => Get.to(
                    () => const HomeView(),
                    preventDuplicates: true,
                    transition: Transition.noTransition,
                  ),
            ),
            _NavItem(
              icon: Icons.calendar_month,
              label: 'Calendar',
              isSelected: currentRoute == '/calendar',
              onTap:
                  () => Get.to(
                    () => const CalendarView(),
                    preventDuplicates: true,
                    transition: Transition.noTransition,
                  ),
            ),
            _NavItem(
              icon: Icons.bar_chart,
              label: 'Graph',
              isSelected: currentRoute == '/graph',
              onTap:
                  () => Get.to(
                    () => const GraphView(),
                    preventDuplicates: true,
                    transition: Transition.noTransition,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.black : Colors.grey),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
