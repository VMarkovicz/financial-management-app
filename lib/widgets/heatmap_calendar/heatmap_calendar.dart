import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HeatmapCalendar extends StatelessWidget {
  final void Function(DateTime)? onClick;

  const HeatmapCalendar({super.key, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 12, color: Colors.black),
        child: HeatMapCalendar(
          defaultColor: Color(0xFFDCDCDC),
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
          colorsets: const {1: Color(0xFF68E093), 2: Color(0xFFE0686A)},
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
