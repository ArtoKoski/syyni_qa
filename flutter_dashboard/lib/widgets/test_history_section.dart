import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/test_history.dart';
import '../providers/app_settings_provider.dart';
import '../services/report_service.dart';
import '../theme/app_colors.dart';
import 'history_line_chart.dart';

class TestHistorySection extends StatelessWidget {
  final String selectedSource;
  final String lastRun;

  const TestHistorySection({
    super.key,
    required this.selectedSource,
    required this.lastRun,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test History',
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            FutureBuilder<List<HistoryItem>>(
              future: ReportService().loadHistory(source: selectedSource),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Virhe: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final history = snapshot.data!;

                if (history.isEmpty) {
                  return Center(
                    child: Text(
                      'No test history available',
                      style: TextStyle(color: AppColors.text(context)),
                    ),
                  );
                }

                if (settings.dashboardWidget == 'lineChart') {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: HistoryLineChart(history: history),
                  );
                }

                final limitedHistory = history.reversed.take(10).toList();

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: limitedHistory.length,
                  itemBuilder: (context, index) {
                    final item = limitedHistory[index];

                    return Card(
                      color: AppColors.background(context),
                      child: ListTile(
                        title: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: item.source == 'github'
                                    ? Colors.blue.withOpacity(0.2)
                                    : Colors.teal.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item.source == 'github'
                                    ? '☁ GitHub'
                                    : '💻 Local',
                                style: TextStyle(
                                  color: item.source == 'github'
                                      ? Colors.blue
                                      : Colors.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                item.date,
                                style: TextStyle(
                                  color: AppColors.text(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          'Passed: ${item.passedTests} | Failed: ${item.failedTests}',
                          style: TextStyle(color: AppColors.text(context)),
                        ),
                        trailing: Text(
                          item.totalTests.toString(),
                          style: const TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 30),

            Text(
              'Last Run: $lastRun',
              style: TextStyle(color: AppColors.text(context), fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
