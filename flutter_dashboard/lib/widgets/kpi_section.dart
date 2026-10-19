import 'package:flutter/material.dart';

import '../models/test_result.dart';
import '../theme/app_colors.dart';

class KpiSection extends StatelessWidget {
  final TestResult data;

  const KpiSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final passRate = data.totalTests == 0
        ? '0'
        : ((data.passedTests / data.totalTests) * 100).toStringAsFixed(1);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth > 1200
            ? (constraints.maxWidth - 48) / 4
            : constraints.maxWidth > 700
            ? (constraints.maxWidth - 16) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: cardWidth,
              child: _buildCard(
                context,
                'Tests',
                data.totalTests.toString(),
                Colors.blue,
              ),
            ),

            SizedBox(
              width: cardWidth,
              child: _buildCard(
                context,
                'Passed',
                data.passedTests.toString(),
                Colors.green,
              ),
            ),

            SizedBox(
              width: cardWidth,
              child: _buildCard(
                context,
                'Failed',
                data.failedTests.toString(),
                Colors.red,
              ),
            ),

            SizedBox(
              width: cardWidth,
              child: _buildCard(
                context,
                'Pass Rate',
                '$passRate%',
                Colors.orange,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    String value,
    Color color,
  ) {
    return Card(
      color: AppColors.card(context),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(title, style: TextStyle(color: AppColors.text(context))),
          ],
        ),
      ),
    );
  }
}
