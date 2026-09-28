import 'package:flutter/material.dart';

import '../models/failed_test.dart';
import '../models/test_execution.dart';
import '../models/test_result.dart';
import '../services/report_service.dart';
import '../theme/app_colors.dart';

class ApiTestsScreen extends StatelessWidget {
  const ApiTestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),

      appBar: AppBar(
        backgroundColor: Colors.blue,

        leading: const Icon(Icons.api, color: Colors.white),

        title: const Text('API Tests'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'API Test Overview',
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue),
              ),
              child: const Row(
                children: [
                  Icon(Icons.api, color: Colors.blue),
                  SizedBox(width: 12),
                  Text('REST API monitoring and endpoint validation'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            FutureBuilder<TestResult>(
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
                      'API Tests',
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

            _sectionTitle(context, 'API Endpoint Coverage'),

            Card(
              color: AppColors.card(context),

              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text('GET /products'),
                  ),

                  ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text('GET /product/{id}'),
                  ),

                  ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text('POST /cart'),
                  ),

                  ListTile(
                    leading: Icon(Icons.cancel, color: Colors.red),
                    title: Text('POST /checkout'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            _sectionTitle(context, 'Slowest API Endpoints'),

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

            _sectionTitle(context, 'Failed API Tests'),

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
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            _sectionTitle(context, 'API Health'),

            Card(
              color: AppColors.card(context),

              child: const Padding(
                padding: EdgeInsets.all(20),

                child: LinearProgressIndicator(value: 0.92, minHeight: 16),
              ),
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
        style: const TextStyle(
          color: Colors.blue,
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
