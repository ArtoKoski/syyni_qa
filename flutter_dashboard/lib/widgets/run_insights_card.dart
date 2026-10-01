import 'package:flutter/material.dart';

class RunInsightsCard extends StatelessWidget {
  final double bestPassRate;
  final double worstPassRate;
  final double averageFailedTests;
  final double averageDurationSeconds;

  const RunInsightsCard({
    super.key,
    required this.bestPassRate,
    required this.worstPassRate,
    required this.averageFailedTests,
    required this.averageDurationSeconds,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'RUN INSIGHTS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Text('Best Pass Rate: ${bestPassRate.toStringAsFixed(1)}%'),

            Text('Worst Pass Rate: ${worstPassRate.toStringAsFixed(1)}%'),

            const Divider(),

            Text(
              'Average Failed Tests: ${averageFailedTests.toStringAsFixed(1)}',
            ),

            Text(
              'Average Duration: ${averageDurationSeconds.toStringAsFixed(1)} s',
            ),
          ],
        ),
      ),
    );
  }
}
