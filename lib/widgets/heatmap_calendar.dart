import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:financial_management_app/theme/app_theme.dart';

class HeatmapCalendar extends StatelessWidget {
  final void Function(DateTime)? onClick;
  final void Function(DateTime)? onMonthChange;
  final Map<DateTime, int> datesHeatmap;

  const HeatmapCalendar({
    super.key,
    this.onClick,
    required this.datesHeatmap,
    this.onMonthChange,
  });

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
          datasets: datesHeatmap,
          onMonthChange: (DateTime date) {
            if (onMonthChange != null) {
              onMonthChange!(date);
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(date.toString())));
            }
          },
          colorsets: {1: AppTheme.success, 2: AppTheme.error},
          onClick: (DateTime value) {
            if (onClick != null) {
              onClick!(value);
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(value.toString())));
            }
          },
        ),
      ),
    );
  }
}
