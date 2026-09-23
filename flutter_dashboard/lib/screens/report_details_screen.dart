import 'package:flutter/material.dart';

import '../models/test_history.dart';
import '../theme/app_colors.dart';
import '../widgets/latest_failure_screenshot.dart';

class ReportDetailsScreen extends StatelessWidget {
  final HistoryItem report;

  const ReportDetailsScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final passRate = report.totalTests == 0
        ? 0
        : (report.passedTests / report.totalTests) * 100;

    return Scaffold(
      backgroundColor: AppColors.background(context),

      appBar: AppBar(
        backgroundColor: AppColors.card(context),
        title: const Text('Report Details'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              report.date,
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                _metricCard(
                  context,
                  'Tests',
                  report.totalTests.toString(),
                  Colors.blue,
                ),

                _metricCard(
                  context,
                  'Passed',
                  report.passedTests.toString(),
                  Colors.green,
                ),

                _metricCard(
                  context,
                  'Failed',
                  report.failedTests.toString(),
                  Colors.red,
                ),

                _metricCard(
                  context,
                  'Pass Rate',
                  '${passRate.toStringAsFixed(1)}%',
                  Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 20),

            Card(
              color: AppColors.card(context),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Execution Details',
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text('Date: ${report.date}'),

                    Text(
                      'Duration: ${(report.duration / 1000).toStringAsFixed(1)} s',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              'Failed Test Details',
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              color: AppColors.card(context),

              child: report.failedTestsDetails.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No failed tests'),
                    )
                  : Column(
                      children: report.failedTestsDetails.map<Widget>((test) {
                        return ListTile(
                          leading: const Icon(Icons.error, color: Colors.red),

                          title: Text(test['name'].toString()),

                          subtitle: Text(test['error'].toString()),
                        );
                      }).toList(),
                    ),
            ),

            const SizedBox(height: 30),

            Text(
              'Slowest Tests',
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              color: AppColors.card(context),

              child: report.slowestTests.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No slowest test data'),
                    )
                  : Column(
                      children: report.slowestTests.map<Widget>((test) {
                        return ListTile(
                          title: Text(test['name'].toString()),

                          trailing: Text(
                            '${(test['duration'] / 1000).toStringAsFixed(1)} s',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),

            const SizedBox(height: 30),

            Text(
              'Latest Failed Screenshot',
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const LatestFailureScreenshot(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _metricCard(
    BuildContext context,
    String title,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Card(
        color: AppColors.card(context),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(title, style: TextStyle(color: AppColors.text(context))),
            ],
          ),
        ),
      ),
    );
  }
}
