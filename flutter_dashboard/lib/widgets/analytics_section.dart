import 'package:flutter/material.dart';

import '../models/test_history.dart';
import '../services/report_service.dart';
import '../theme/app_colors.dart';

import 'environment_comparison_card.dart';
import 'pass_rate_trend_chart.dart';
import 'quality_score_card.dart';
import 'run_insights_card.dart';
import 'test_type_analytics_card.dart';

class AnalyticsSection extends StatelessWidget {
  final String selectedSource;

  const AnalyticsSection({super.key, required this.selectedSource});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HistoryItem>>(
      future: ReportService().loadHistory(source: selectedSource),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final history = snapshot.data!;

        if (history.isEmpty) {
          return const SizedBox();
        }

        return Column(
          children: [
            _buildQualityScore(history),

            const SizedBox(height: 20),

            _buildAnalytics(context, history),

            const SizedBox(height: 20),

            _buildInsights(history),

            const SizedBox(height: 20),

            _buildPassRateTrend(context, history),
          ],
        );
      },
    );
  }

  Widget _buildQualityScore(List<HistoryItem> history) {
    final latest = history.last;

    final passRate = latest.totalTests == 0
        ? 0.0
        : (latest.passedTests / latest.totalTests) * 100;

    final failurePenalty = latest.failedTests * 2;

    final durationPenalty = (latest.duration / 1000) > 60 ? 5 : 0;

    double score = passRate - failurePenalty - durationPenalty;

    score = score.clamp(0, 100);

    return QualityScoreCard(
      score: score,
      passRate: passRate,
      failedTests: latest.failedTests,
      durationSeconds: latest.duration / 1000,
    );
  }

  Widget _buildAnalytics(BuildContext context, List<HistoryItem> history) {
    final apiRuns = history.where((h) => h.testType == 'API').length;

    final uiRuns = history.where((h) => h.testType == 'UI').length;

    final mixedRuns = history.where((h) => h.testType == 'Mixed').length;

    final localRuns = history.where((h) => h.source == 'local').length;

    final githubRuns = history.where((h) => h.source == 'github').length;

    return Column(
      children: [
        TestTypeAnalyticsCard(
          apiRuns: apiRuns,
          uiRuns: uiRuns,
          mixedRuns: mixedRuns,
        ),

        const SizedBox(height: 20),

        EnvironmentComparisonCard(localRuns: localRuns, githubRuns: githubRuns),
      ],
    );
  }

  Widget _buildInsights(List<HistoryItem> history) {
    final passRates = history.map((h) {
      if (h.totalTests == 0) {
        return 0.0;
      }

      return (h.passedTests / h.totalTests) * 100;
    }).toList();

    final bestPassRate = passRates.reduce((a, b) => a > b ? a : b);

    final worstPassRate = passRates.reduce((a, b) => a < b ? a : b);

    final averageFailedTests =
        history.map((h) => h.failedTests).reduce((a, b) => a + b) /
        history.length;

    final averageDurationSeconds =
        history.map((h) => h.duration).reduce((a, b) => a + b) /
        history.length /
        1000;

    return RunInsightsCard(
      bestPassRate: bestPassRate,
      worstPassRate: worstPassRate,
      averageFailedTests: averageFailedTests,
      averageDurationSeconds: averageDurationSeconds,
    );
  }

  Widget _buildPassRateTrend(BuildContext context, List<HistoryItem> history) {
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
              'Pass Rate Trend',
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            PassRateTrendChart(history: history),
          ],
        ),
      ),
    );
  }
}
