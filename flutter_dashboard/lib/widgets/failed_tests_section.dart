import 'package:flutter/material.dart';

import '../models/failed_test.dart';
import '../services/report_service.dart';
import '../theme/app_colors.dart';

class FailedTestsSection extends StatelessWidget {
  final String selectedSource;

  const FailedTestsSection({super.key, required this.selectedSource});

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
            'Failed Test Details',
            style: TextStyle(
              color: AppColors.text(context),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          FutureBuilder<List<FailedTest>>(
            future: ReportService().loadFailedTests(source: selectedSource),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Failed to load failed tests');
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final tests = snapshot.data!;

              if (tests.isEmpty) {
                return const Text('No failed tests');
              }

              return Column(
                children: tests.map((test) {
                  return ListTile(
                    leading: const Icon(Icons.error, color: Colors.red),
                    title: Text(
                      test.name,
                      style: TextStyle(color: AppColors.text(context)),
                    ),
                    subtitle: Text(
                      test.error,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
