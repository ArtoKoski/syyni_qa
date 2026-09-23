import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/test_history.dart';

class PassRateTrendChart extends StatelessWidget {
  final List<HistoryItem> history;

  const PassRateTrendChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(child: Text('No pass rate data available'));
    }

    final limitedHistory = history.length > 10
        ? history.sublist(history.length - 10)
        : history;

    final spots = limitedHistory.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      final passRate = item.totalTests == 0
          ? 0.0
          : (item.passedTests / item.totalTests) * 100;

      return FlSpot(index.toDouble(), passRate);
    }).toList();

    return SizedBox(
      height: 250,

      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 100,

          gridData: FlGridData(show: true),

          borderData: FlBorderData(show: true),

          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,

                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),

            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,

                getTitlesWidget: (value, meta) {
                  if (value != value.roundToDouble()) {
                    return const SizedBox();
                  }

                  final index = value.toInt();

                  if (index >= limitedHistory.length) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      limitedHistory[index].date.split(' ').first,
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),

            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
          ),

          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final item = limitedHistory[spot.x.toInt()];

                  final icon = item.source == 'github' ? '☁' : '💻';

                  return LineTooltipItem(
                    '$icon ${item.source.toUpperCase()}\n'
                    'Pass Rate: '
                    '${spot.y.toStringAsFixed(1)}%',

                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),

          lineBarsData: [
            LineChartBarData(
              spots: spots,

              isCurved: true,

              color: Colors.teal,

              barWidth: 4,

              dotData: FlDotData(
                show: true,

                getDotPainter: (spot, percent, barData, index) {
                  final item = limitedHistory[index];

                  return FlDotCirclePainter(
                    radius: 5,

                    color: item.source == 'github' ? Colors.blue : Colors.teal,

                    strokeWidth: 2,

                    strokeColor: Colors.white,
                  );
                },
              ),

              belowBarData: BarAreaData(
                show: true,

                color: Colors.teal.withAlpha(38),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
