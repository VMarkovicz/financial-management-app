import 'package:financial_management_app/widgets/heatmap_calendar/heatmap_calendar.dart';
import 'package:flutter/material.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Calendar",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: DropdownButton(
          items: [
            DropdownMenuItem(value: "1", child: Text("USD")),
            DropdownMenuItem(value: "2", child: Text("EUR")),
          ],
          onChanged: (value) {},
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: HeatmapCalendar(
            onClick: (value) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(value.toString())));
            },
          ),
        ),
      ),
    );
  }
}
