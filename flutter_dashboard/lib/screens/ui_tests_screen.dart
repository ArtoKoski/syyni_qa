import 'package:flutter/material.dart';

import '../services/report_service.dart';
import '../models/test_execution.dart';
import '../models/failed_test.dart';
import '../theme/app_colors.dart';

class UiTestsScreen extends StatelessWidget {
  const UiTestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),

      appBar: AppBar(title: const Text('UI Tests')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'UI Test Overview',
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            FutureBuilder(
              future: ReportService().loadResults(),

              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final result = snapshot.data!;

                final passRate = result.totalTests == 0
                    ? 0
                    : (result.passedTests / result.totalTests) * 100;

                return Row(
                  children: [
                    _metricCard(
                      context,
                      'UI Tests',
                      result.totalTests.toString(),
                      Colors.blue,
                    ),

                    _metricCard(
                      context,
                      'Passed',
                      result.passedTests.toString(),
                      Colors.green,
                    ),

                    _metricCard(
                      context,
                      'Failed',
                      result.failedTests.toString(),
                      Colors.red,
                    ),

                    _metricCard(
                      context,
                      'Pass Rate',
                      '${passRate.toStringAsFixed(1)}%',
                      Colors.orange,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 25),

            _sectionTitle(context, 'UI Test Coverage'),

            Card(
              color: AppColors.card(context),

              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text('Home Page'),
                  ),

                  ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text('Product Search'),
                  ),

                  ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text('Product Details'),
                  ),

                  ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text('Cart'),
                  ),

                  ListTile(
                    leading: Icon(Icons.cancel, color: Colors.red),
                    title: Text('Checkout'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            _sectionTitle(context, 'Slowest UI Tests'),

            FutureBuilder<List<TestExecution>>(
              future: ReportService().loadSlowestTests(),

              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final tests = snapshot.data!;

                return Card(
                  color: AppColors.card(context),

                  child: Column(
                    children: tests.map((test) {
                      return ListTile(
                        title: Text(test.name),

                        trailing: Text(
                          '${(test.duration / 1000).toStringAsFixed(1)} s',
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            _sectionTitle(context, 'Failed UI Tests'),

            FutureBuilder<List<FailedTest>>(
              future: ReportService().loadFailedTests(),

              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final tests = snapshot.data!;

                return Card(
                  color: AppColors.card(context),

                  child: Column(
                    children: tests.map((test) {
                      return ListTile(
                        leading: const Icon(Icons.error, color: Colors.red),

                        title: Text(test.name),

                        subtitle: Text(
                          test.error,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.text(context),
          fontSize: 20,
          fontWeight: FontWeight.bold,
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
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
