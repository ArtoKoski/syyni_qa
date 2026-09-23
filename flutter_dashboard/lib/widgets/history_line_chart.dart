import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/test_history.dart';

class HistoryLineChart extends StatelessWidget {
  final List<HistoryItem> history;

  const HistoryLineChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final limitedHistory = history.length > 10
        ? history.sublist(history.length - 10)
        : history;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.circle, color: Colors.green, size: 12),

            const SizedBox(width: 6),

            Text(
              'Passed',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),

            const SizedBox(width: 20),

            const Icon(Icons.circle, color: Colors.red, size: 12),

            const SizedBox(width: 6),

            Text(
              'Failed',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ),

        const SizedBox(height: 20),

        SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              minY: 0,

              gridData: FlGridData(show: true, drawVerticalLine: false),

              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    if (touchedSpots.isEmpty) {
                      return [];
                    }

                    final firstSpot = touchedSpots.first;

                    final item = limitedHistory[firstSpot.x.toInt()];

                    final icon = item.source == 'github' ? '☁' : '💻';

                    return touchedSpots.map((spot) {
                      if (spot != firstSpot) {
                        return null;
                      }

                      return LineTooltipItem(
                        '$icon ${item.source.toUpperCase()}\n'
                        'Passed: ${item.passedTests}\n'
                        'Failed: ${item.failedTests}',

                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),

              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.white24),
              ),

              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),

                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
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
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          limitedHistory[index].date.split(' ').first,
                          style: const TextStyle(fontSize: 9),
                        ),
                      );
                    },
                  ),
                ),

                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 32),
                ),
              ),

              lineBarsData: [
                LineChartBarData(
                  color: Colors.green,

                  isCurved: true,

                  barWidth: 4,

                  dotData: FlDotData(show: true),

                  spots: limitedHistory
                      .asMap()
                      .entries
                      .map(
                        (e) => FlSpot(
                          e.key.toDouble(),
                          e.value.passedTests.toDouble(),
                        ),
                      )
                      .toList(),
                ),

                LineChartBarData(
                  color: Colors.red,

                  isCurved: true,

                  barWidth: 4,

                  dotData: FlDotData(show: true),

                  spots: limitedHistory
                      .asMap()
                      .entries
                      .map(
                        (e) => FlSpot(
                          e.key.toDouble(),
                          e.value.failedTests.toDouble(),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
