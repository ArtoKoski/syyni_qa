import 'package:flutter/material.dart';

class TestTypeAnalyticsCard extends StatelessWidget {
  final int apiRuns;
  final int uiRuns;
  final int mixedRuns;

  const TestTypeAnalyticsCard({
    super.key,
    required this.apiRuns,
    required this.uiRuns,
    required this.mixedRuns,
  });

  @override
  Widget build(BuildContext context) {
    final totalRuns = apiRuns + uiRuns + mixedRuns;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TEST DISTRIBUTION',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text('API Runs: $apiRuns'),
            Text('UI Runs: $uiRuns'),
            Text('Mixed Runs: $mixedRuns'),

            const Divider(),

            Text('Total Runs: $totalRuns'),
          ],
        ),
      ),
    );
  }
}
