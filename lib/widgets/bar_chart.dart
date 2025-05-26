import 'package:flutter/material.dart';
import 'package:material_charts/material_charts.dart';

class ChartData {
  final double value;
  final String label;

  ChartData({required this.value, required this.label});
}

class BarChart extends StatelessWidget {
  final List<ChartData> data;
  final Color barColor;

  const BarChart({super.key, required this.data, this.barColor = Colors.blue});

 @override
  Widget build(BuildContext context) {
    final allZero = data.isEmpty || data.every((item) => item.value == 0.0);

    if (allZero) {
      return Container(
        height: 150,
        width: double.infinity,
        alignment: Alignment.center,
        color: Colors.white,
        child: const Text(
          'No data available',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return MaterialBarChart(
      width: double.infinity,
      height: 150,
      data:
          data
              .map(
                (item) => BarChartData(
                  value: item.value,
                  label: item.label,
                  color: barColor,
                ),
              )
              .toList(),
      style: BarChartStyle(
        backgroundColor: Colors.white,
        labelStyle: const TextStyle(fontSize: 14, color: Colors.black),
        valueStyle: const TextStyle(fontSize: 12, color: Colors.black),
        barSpacing: 0.3,
        cornerRadius: 6.0,
        gradientEffect: false,
      ),
      showGrid: false,
      showValues: true,
    );
  }
}
