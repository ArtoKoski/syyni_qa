import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/test_history.dart';

class TestHistoryChart extends StatelessWidget {
  final List<HistoryItem> history;

  const TestHistoryChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(
        child: Text(
          'No history available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return LineChart(
      LineChartData(
        backgroundColor: Colors.transparent,

        gridData: FlGridData(show: true),

        borderData: FlBorderData(show: true),

        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),

        lineBarsData: [
          LineChartBarData(
            isCurved: true,

            color: Colors.green,

            barWidth: 4,

            dotData: FlDotData(show: true),

            spots: history
                .asMap()
                .entries
                .map(
                  (e) =>
                      FlSpot(e.key.toDouble(), e.value.passedTests.toDouble()),
                )
                .toList(),
          ),

          LineChartBarData(
            isCurved: true,

            color: Colors.red,

            barWidth: 4,

            dotData: FlDotData(show: true),

            spots: history
                .asMap()
                .entries
                .map(
                  (e) =>
                      FlSpot(e.key.toDouble(), e.value.failedTests.toDouble()),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
