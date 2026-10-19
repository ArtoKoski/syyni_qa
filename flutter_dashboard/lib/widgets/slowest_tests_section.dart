import 'package:flutter/material.dart';

import '../models/test_execution.dart';
import '../services/report_service.dart';
import '../theme/app_colors.dart';

class SlowestTestsSection extends StatelessWidget {
  final String selectedSource;

  const SlowestTestsSection({super.key, required this.selectedSource});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Slowest Tests',
            style: TextStyle(
              color: AppColors.text(context),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          FutureBuilder<List<TestExecution>>(
            future: ReportService().loadSlowestTests(source: selectedSource),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Failed to load test execution data');
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final tests = snapshot.data!;

              if (tests.isEmpty) {
                return const Text('No test execution data available');
              }

              return Column(
                children: tests.map((test) {
                  return ListTile(
                    title: Text(
                      test.name,
                      style: TextStyle(color: AppColors.text(context)),
                    ),
                    trailing: Text(
                      '${(test.duration / 1000).toStringAsFixed(1)} s',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
