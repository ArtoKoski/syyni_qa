import 'package:flutter/material.dart';

class EnvironmentComparisonCard extends StatelessWidget {
  final int localRuns;
  final int githubRuns;

  const EnvironmentComparisonCard({
    super.key,
    required this.localRuns,
    required this.githubRuns,
  });

  @override
  Widget build(BuildContext context) {
    final totalRuns = localRuns + githubRuns;

    final mostUsed = localRuns > githubRuns
        ? 'Local'
        : githubRuns > localRuns
        ? 'GitHub'
        : 'Equal Usage';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ENVIRONMENT COMPARISON',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Text('💻 Local Runs: $localRuns'),
            Text('☁ GitHub Runs: $githubRuns'),

            const Divider(),

            Text('Total Runs: $totalRuns'),

            Text('Most Used Environment: $mostUsed'),
          ],
        ),
      ),
    );
  }
}
