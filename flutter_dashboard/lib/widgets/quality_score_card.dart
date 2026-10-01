import 'package:flutter/material.dart';

class QualityScoreCard extends StatelessWidget {
  final double score;
  final double passRate;
  final int failedTests;
  final double durationSeconds;

  const QualityScoreCard({
    super.key,
    required this.score,
    required this.passRate,
    required this.failedTests,
    required this.durationSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final color = score >= 90
        ? Colors.green
        : score >= 75
        ? Colors.orange
        : Colors.red;

    final label = score >= 90
        ? 'Excellent'
        : score >= 75
        ? 'Good'
        : 'Needs Attention';

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'QA HEALTH SCORE',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Text(
              '${score.toStringAsFixed(0)}/100',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            LinearProgressIndicator(
              value: score / 100,
              minHeight: 12,
              color: color,
              backgroundColor: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MetricItem(
                  title: 'PASS RATE',
                  value: '${passRate.toStringAsFixed(1)}%',
                  color: Colors.green,
                  icon: Icons.check_circle,
                ),

                _MetricItem(
                  title: 'FAILURES',
                  value: failedTests.toString(),
                  color: Colors.red,
                  icon: Icons.error,
                ),

                _MetricItem(
                  title: 'DURATION',
                  value: '${durationSeconds.toStringAsFixed(1)} s',
                  color: Colors.blue,
                  icon: Icons.timer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _MetricItem({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color),

        const SizedBox(height: 6),

        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 4),

        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
