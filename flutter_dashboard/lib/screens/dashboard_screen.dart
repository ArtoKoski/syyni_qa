import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/test_history.dart';
import '../models/test_result.dart';
import '../providers/app_settings_provider.dart';
import '../services/report_service.dart';
import '../theme/app_colors.dart';
import '../widgets/history_line_chart.dart';
import '../widgets/live_clock.dart';
import '../widgets/sidebar.dart';
import '../models/test_execution.dart';
import '../models/failed_test.dart';
import '../widgets/pass_rate_trend_chart.dart';
import '../widgets/latest_failure_screenshot.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedSource = 'local';
  bool isRunning = false;
  late Future<TestResult> futureResults;

  @override
  void initState() {
    super.initState();

    futureResults = ReportService().loadResults(source: selectedSource);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background(context),

      body: Row(
        children: [
          const DashboardSidebar(),

          Expanded(
            child: FutureBuilder<TestResult>(
              future: futureResults,

              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Virhe: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!;

                final passRate = data.totalTests == 0
                    ? '0'
                    : ((data.passedTests / data.totalTests) * 100)
                          .toStringAsFixed(1);

                return Padding(
                  padding: const EdgeInsets.all(20),

                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.theater_comedy,
                              color: Colors.teal,
                              size: 32,
                            ),

                            const SizedBox(width: 12),

                            Text(
                              'Syyni QA',
                              style: TextStyle(
                                color: AppColors.text(context),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const Spacer(),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),

                              decoration: BoxDecoration(
                                color: AppColors.card(context),

                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: Row(
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  Icon(
                                    Icons.schedule,
                                    color: AppColors.text(context),
                                    size: 18,
                                  ),

                                  const SizedBox(width: 8),

                                  const LiveClock(),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        ElevatedButton.icon(
                          onPressed: isRunning
                              ? null
                              : () async {
                                  setState(() {
                                    isRunning = true;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Playwright testit käynnistyvät...',
                                      ),
                                    ),
                                  );

                                  try {
                                    await ReportService().runTests();

                                    if (!mounted) {
                                      return;
                                    }

                                    setState(() {
                                      isRunning = false;

                                      futureResults = ReportService()
                                          .loadResults(source: selectedSource);
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Testit suoritettu'),
                                      ),
                                    );
                                  } catch (e) {
                                    if (!mounted) {
                                      return;
                                    }

                                    setState(() {
                                      isRunning = false;
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Virhe: $e')),
                                    );
                                  }
                                },

                          icon: Icon(
                            isRunning
                                ? Icons.hourglass_bottom
                                : Icons.play_arrow,
                          ),

                          label: Text(
                            isRunning ? 'Running...' : 'Run Local Tests',
                          ),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 30),

                        ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              await ReportService().runGitHubTests();

                              if (!context.mounted) {
                                return;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'GitHub Actions workflow started',
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) {
                                return;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('GitHub Error: $e')),
                              );
                            }
                          },

                          icon: const Icon(Icons.cloud),

                          label: const Text('Run CI/CD Tests'),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.card(context),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.cloud_done, color: Colors.blue),

                              const SizedBox(width: 12),

                              Text(
                                'GitHub Actions integration enabled',
                                style: TextStyle(
                                  color: AppColors.text(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Text(
                              'Source:',
                              style: TextStyle(
                                color: AppColors.text(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(width: 12),

                            DropdownButton<String>(
                              value: selectedSource,

                              items: const [
                                DropdownMenuItem(
                                  value: 'local',
                                  child: Text('Local'),
                                ),

                                DropdownMenuItem(
                                  value: 'github',
                                  child: Text('GitHub'),
                                ),

                                DropdownMenuItem(
                                  value: 'all',
                                  child: Text('All'),
                                ),
                              ],

                              onChanged: (value) {
                                if (value == null) return;

                                setState(() {
                                  selectedSource = value;

                                  futureResults = ReportService().loadResults(
                                    source: selectedSource,
                                  );
                                });
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            _buildCard(
                              context,
                              'Tests',
                              data.totalTests.toString(),
                              Colors.blue,
                            ),

                            _buildCard(
                              context,
                              'Passed',
                              data.passedTests.toString(),
                              Colors.green,
                            ),

                            _buildCard(
                              context,
                              'Failed',
                              data.failedTests.toString(),
                              Colors.red,
                            ),

                            _buildCard(
                              context,
                              'Pass Rate',
                              '$passRate%',
                              Colors.orange,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.card(context),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: FutureBuilder<List<HistoryItem>>(
                              future: ReportService().loadHistory(
                                source: selectedSource,
                              ),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pass Rate Trend',
                                      style: TextStyle(
                                        color: AppColors.text(context),
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    PassRateTrendChart(history: snapshot.data!),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Container(
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
                                future: ReportService().loadSlowestTests(
                                  source: selectedSource,
                                ),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }

                                  final tests = snapshot.data!;

                                  if (tests.isEmpty) {
                                    return const Text(
                                      'No test execution data available',
                                    );
                                  }

                                  return Column(
                                    children: tests.map((test) {
                                      return ListTile(
                                        title: Text(
                                          test.name,
                                          style: TextStyle(
                                            color: AppColors.text(context),
                                          ),
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
                        ),

                        const SizedBox(height: 20),

                        Container(
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

                              const LatestFailureScreenshot(),

                              const SizedBox(height: 20),

                              const SizedBox(height: 10),

                              FutureBuilder<List<FailedTest>>(
                                future: ReportService().loadFailedTests(
                                  source: selectedSource,
                                ),

                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }

                                  final tests = snapshot.data!;

                                  if (tests.isEmpty) {
                                    return const Text('No failed tests');
                                  }

                                  return Column(
                                    children: tests.map((test) {
                                      return ListTile(
                                        leading: const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),

                                        title: Text(
                                          test.name,
                                          style: TextStyle(
                                            color: AppColors.text(context),
                                          ),
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
                        ),

                        const SizedBox(height: 30),

                        Container(
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
                                  future: ReportService().loadHistory(
                                    source: selectedSource,
                                  ),

                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          'Virhe: ${snapshot.error}',
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      );
                                    }

                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    final history = snapshot.data!;

                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    final limitedHistory = history.reversed
                                        .take(10)
                                        .toList();

                                    if (history.isEmpty) {
                                      return Center(
                                        child: Text(
                                          'No test history available',
                                          style: TextStyle(
                                            color: AppColors.text(context),
                                          ),
                                        ),
                                      );
                                    }

                                    if (settings.dashboardWidget ==
                                        'lineChart') {
                                      return Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: HistoryLineChart(
                                          history: history,
                                        ),
                                      );
                                    }

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),

                                      reverse: true,
                                      itemCount: limitedHistory.length,

                                      itemBuilder: (context, index) {
                                        final item = limitedHistory[index];

                                        return Card(
                                          color: AppColors.background(context),

                                          child: ListTile(
                                            title: Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),

                                                  decoration: BoxDecoration(
                                                    color:
                                                        item.source == 'github'
                                                        ? Colors.blue
                                                              .withOpacity(0.2)
                                                        : Colors.teal
                                                              .withOpacity(0.2),

                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),

                                                  child: Text(
                                                    item.source == 'github'
                                                        ? '☁ GitHub'
                                                        : '💻 Local',

                                                    style: TextStyle(
                                                      color:
                                                          item.source ==
                                                              'github'
                                                          ? Colors.blue
                                                          : Colors.teal,

                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(width: 12),

                                                Expanded(
                                                  child: Text(
                                                    item.date,
                                                    style: TextStyle(
                                                      color: AppColors.text(
                                                        context,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            subtitle: Text(
                                              'Passed: ${item.passedTests} | Failed: ${item.failedTests}',
                                              style: TextStyle(
                                                color: AppColors.text(context),
                                              ),
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
                                  'Last Run: ${data.lastRun}',
                                  style: TextStyle(
                                    color: AppColors.text(context),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Card(
        color: AppColors.card(context),

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
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
      ),
    );
  }
}
