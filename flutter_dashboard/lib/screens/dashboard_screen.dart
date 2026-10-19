import 'package:flutter/material.dart';

import '../models/test_result.dart';
import '../services/report_service.dart';
import '../theme/app_colors.dart';
import '../widgets/live_clock.dart';
import '../widgets/sidebar.dart';
import '../services/settings_service.dart';
import '../services/dashboard_refresh_service.dart';
import '../widgets/test_history_section.dart';
import '../widgets/slowest_tests_section.dart';
import '../widgets/failed_tests_section.dart';
import '../widgets/analytics_section.dart';
import '../widgets/dashboard_controls.dart';
import '../widgets/latest_failure_section.dart';
import '../widgets/kpi_section.dart';
import '../widgets/build_info_section.dart';

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

  final ScrollController _scrollController = ScrollController();
  final SettingsService _settingsService = SettingsService();

  Future<void> _openPlaywrightReport() async {
    final uri = Uri.parse(ReportService.playwrightReportUrl);

    await launchUrl(uri, mode: LaunchMode.externalApplication);
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

    futureResults = Future.value(
      TestResult(totalTests: 0, passedTests: 0, failedTests: 0, lastRun: ''),
    );

    DashboardRefreshService.refreshNotifier.addListener(_hardRefresh);

    _loadBackendUrl();
  }

  Future<void> _hardRefresh() async {
    if (mounted) {
      setState(() {
        futureResults = ReportService().loadResults(source: selectedSource);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();

    DashboardRefreshService.refreshNotifier.removeListener(_hardRefresh);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

                return Padding(
                  padding: const EdgeInsets.all(20),

                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    interactive: true,
                    thickness: 12,

                    child: SingleChildScrollView(
                      controller: _scrollController,
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

                          // Environment selection and test execution controls
                          DashboardControls(
                            selectedSource: selectedSource,
                            isMockMode: ReportService.mockMode,

                            onSelectLocal: () async {
                              final localUrl = await _settingsService
                                  .loadBackendUrl();

                              setState(() {
                                ReportService.baseUrl = localUrl;

                                selectedSource = 'local';

                                futureResults = ReportService().loadResults(
                                  source: 'local',
                                );
                              });
                            },
                            onSelectGitHub: () {
                              setState(() {
                                ReportService.baseUrl =
                                    'https://verkkokauppa-1.onrender.com';

                                selectedSource = 'github';

                                futureResults = ReportService().loadResults(
                                  source: 'github',
                                );
                              });
                            },

                            onRunLocalTests: () async {
                              setState(() {
                                isRunning = true;
                              });

                              await ReportService().runTests();

                              setState(() {
                                isRunning = false;
                                selectedSource = 'all';

                                futureResults = ReportService().loadResults(
                                  source: 'all',
                                );
                              });
                            },

                            onRunGitHubTests: () async {
                              await ReportService().runGitHubTests();
                            },

                            onOpenPlaywrightReport: _openPlaywrightReport,

                            onSourceChanged: (source) {
                              setState(() {
                                selectedSource = source;

                                futureResults = ReportService().loadResults(
                                  source: source,
                                );
                              });
                            },
                          ),
                          const SizedBox(height: 20),

                          // Latest build information imported from GitHub Actions
                          const BuildInfoSection(),

                          const SizedBox(height: 20),

                          // Dashboard KPI metrics
                          KpiSection(data: data),

                          const SizedBox(height: 20),

                          // Test analytics, quality score and trend charts
                          AnalyticsSection(selectedSource: selectedSource),

                          const SizedBox(height: 20),

                          // Top 5 slowest test executions
                          SlowestTestsSection(selectedSource: selectedSource),

                          const SizedBox(height: 20),

                          // Latest Playwright failure screenshot
                          const LatestFailureSection(),

                          const SizedBox(height: 20),

                          // Detailed list of failed test cases
                          FailedTestsSection(selectedSource: selectedSource),

                          const SizedBox(height: 20),

                          // Test execution history and historical trends
                          TestHistorySection(
                            selectedSource: selectedSource,
                            lastRun: data.lastRun,
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
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
}
