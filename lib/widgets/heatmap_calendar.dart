import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:financial_management_app/theme/app_theme.dart';

class HeatmapCalendar extends StatelessWidget {
  final void Function(DateTime)? onClick;

  const HeatmapCalendar({super.key, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 12, color: Colors.black),
        child: HeatMapCalendar(
          defaultColor: AppTheme.defaultGrey,
          flexible: true,
          showColorTip: false,
          colorMode: ColorMode.color,
          textColor: Colors.white,
          datasets: {
            DateTime(2025, 1, 6): 1,
            DateTime(2025, 1, 7): 2,
            DateTime(2025, 1, 8): 1,
            DateTime(2025, 1, 9): 2,
            DateTime(2025, 1, 13): 1,
          },
          colorsets: {1: AppTheme.success, 2: AppTheme.error},
          onClick: (value) {
            if (onClick != null) {
              onClick!(value);
              return;
            }
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(value.toString())));
          },
        ),
      ),
    );
  }
}
