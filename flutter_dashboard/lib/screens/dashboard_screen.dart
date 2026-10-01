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
import '../widgets/build_info_card.dart';
import '../models/build_info.dart';
import '../widgets/test_type_analytics_card.dart';
import '../widgets/environment_comparison_card.dart';
import '../widgets/run_insights_card.dart';
import '../widgets/quality_score_card.dart';
import '../services/settings_service.dart';

import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedSource = 'all';
  bool isRunning = false;
  late Future<TestResult> futureResults;

  static const String playwrightReportUrl =
      'http://10.6.128.114:3000/report/index.html';

  final SettingsService _settingsService = SettingsService();

  Future<void> _openPlaywrightReport() async {
    final uri = Uri.parse(playwrightReportUrl);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch Playwright Report');
    }
  }

  Future<void> _loadBackendUrl() async {
    final savedUrl = await _settingsService.loadBackendUrl();

    ReportService.baseUrl = savedUrl;

    if (mounted) {
      setState(() {
        futureResults = ReportService().loadResults(source: selectedSource);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    futureResults = ReportService().loadResults(source: selectedSource);

    _loadBackendUrl();
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

                debugPrint(
                  'total=${data.totalTests}, '
                  'passed=${data.passedTests}, '
                  'failed=${data.failedTests}',
                );

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

                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                final localUrl = await _settingsService
                                    .loadBackendUrl();

                                setState(() {
                                  ReportService.baseUrl = localUrl;

                                  futureResults = ReportService().loadResults(
                                    source: selectedSource,
                                  );
                                });
                              },

                              icon: const Icon(Icons.computer),

                              label: const Text('Local'),

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                              ),
                            ),

                            const SizedBox(width: 12),

                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  ReportService.baseUrl =
                                      'https://verkkokauppa-1.onrender.com';

                                  futureResults = ReportService().loadResults(
                                    source: selectedSource,
                                  );
                                });
                              },

                              icon: const Icon(Icons.cloud),

                              label: const Text('Online'),

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),

                            IconButton(
                              onPressed: () {
                                setState(() {
                                  futureResults = ReportService().loadResults(
                                    source: selectedSource,
                                  );
                                });
                              },

                              tooltip: 'Refresh Dashboard',

                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),

                              style: IconButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.all(1),
                              ),
                            ),
                          ],
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

                        BuildInfoCard(
                          buildInfo: const BuildInfo(
                            branch: 'main',
                            commit: 'c539da0',
                            author: 'Vlad Shpychka',
                            message: 'tokin for dashboard',
                          ),
                        ),

                        const SizedBox(height: 20),

                        ElevatedButton.icon(
                          onPressed: _openPlaywrightReport,

                          icon: const Icon(Icons.open_in_browser),

                          label: const Text('Open Playwright Report'),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
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

                        FutureBuilder<List<HistoryItem>>(
                          future: ReportService().loadHistory(
                            source: selectedSource,
                          ),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }

                            final history = snapshot.data!;

                            if (history.isEmpty) {
                              return const SizedBox();
                            }

                            final latest = history.last;

                            final passRate = latest.totalTests == 0
                                ? 0.0
                                : (latest.passedTests / latest.totalTests) *
                                      100;

                            final failurePenalty = latest.failedTests * 2;

                            final durationPenalty =
                                (latest.duration / 1000) > 60 ? 5 : 0;

                            double score =
                                passRate - failurePenalty - durationPenalty;

                            score = score.clamp(0, 100);

                            return QualityScoreCard(
                              score: score,
                              passRate: passRate,
                              failedTests: latest.failedTests,
                              durationSeconds: latest.duration / 1000,
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        FutureBuilder<List<HistoryItem>>(
                          future: ReportService().loadHistory(
                            source: selectedSource,
                          ),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }

                            final history = snapshot.data!;

                            final apiRuns = history
                                .where((h) => h.testType == 'API')
                                .length;

                            final uiRuns = history
                                .where((h) => h.testType == 'UI')
                                .length;

                            final mixedRuns = history
                                .where((h) => h.testType == 'Mixed')
                                .length;

                            final localRuns = history
                                .where((h) => h.source == 'local')
                                .length;

                            final githubRuns = history
                                .where((h) => h.source == 'github')
                                .length;

                            return Column(
                              children: [
                                TestTypeAnalyticsCard(
                                  apiRuns: apiRuns,
                                  uiRuns: uiRuns,
                                  mixedRuns: mixedRuns,
                                ),

                                const SizedBox(height: 20),

                                EnvironmentComparisonCard(
                                  localRuns: localRuns,
                                  githubRuns: githubRuns,
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        FutureBuilder<List<HistoryItem>>(
                          future: ReportService().loadHistory(
                            source: selectedSource,
                          ),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }

                            final history = snapshot.data!;

                            if (history.isEmpty) {
                              return const SizedBox();
                            }

                            final passRates = history.map((h) {
                              if (h.totalTests == 0) {
                                return 0.0;
                              }

                              return (h.passedTests / h.totalTests) * 100;
                            }).toList();

                            final bestPassRate = passRates.reduce(
                              (a, b) => a > b ? a : b,
                            );

                            final worstPassRate = passRates.reduce(
                              (a, b) => a < b ? a : b,
                            );

                            final averageFailedTests =
                                history
                                    .map((h) => h.failedTests)
                                    .reduce((a, b) => a + b) /
                                history.length;

                            final averageDurationSeconds =
                                history
                                    .map((h) => h.duration)
                                    .reduce((a, b) => a + b) /
                                history.length /
                                1000;

                            return RunInsightsCard(
                              bestPassRate: bestPassRate,
                              worstPassRate: worstPassRate,
                              averageFailedTests: averageFailedTests,
                              averageDurationSeconds: averageDurationSeconds,
                            );
                          },
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
                                'Latest Failure Screenshot',
                                style: TextStyle(
                                  color: AppColors.text(context),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 20),

                              const LatestFailureScreenshot(),
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
