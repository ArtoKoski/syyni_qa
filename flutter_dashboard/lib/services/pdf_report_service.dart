import 'package:pdf/widgets.dart' as pw;

import '../models/test_result.dart';
import '../models/test_history.dart';
import '../models/failed_test.dart';
import '../models/test_execution.dart';

class PdfReportService {
  static Future<pw.Document> generateReport(
    TestResult result,
    List<FailedTest> failedTests,
    List<TestExecution> slowestTests,
    List<HistoryItem> history,
  ) async {
    final pdf = pw.Document();

    // --------------------------------------------------
    // PAGE 1 - SUMMARY
    // --------------------------------------------------

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            'TEST EXECUTION REPORT',
            style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
          ),

          pw.SizedBox(height: 20),

          pw.Text('Unnamed Project', style: const pw.TextStyle(fontSize: 20)),

          pw.SizedBox(height: 20),

          pw.Header(level: 1, text: 'Summary'),

          pw.Text('Total Tests: ${result.totalTests}'),

          pw.Text('Passed Tests: ${result.passedTests}'),

          pw.Text('Failed Tests: ${result.failedTests}'),

          pw.Text('Last Run: ${result.lastRun}'),

          pw.SizedBox(height: 20),

          pw.Header(level: 1, text: 'Failed Test Details'),

          if (failedTests.isEmpty) pw.Text('No failed tests found'),

          ...failedTests.map(
            (test) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 10),

              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,

                children: [
                  pw.Text(
                    test.name,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),

                  pw.Text(test.error),

                  pw.Divider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // --------------------------------------------------
    // PAGE 2 - PERFORMANCE
    // --------------------------------------------------

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 1, text: 'Slowest Tests'),

          if (slowestTests.isEmpty) pw.Text('No execution data available'),

          pw.TableHelper.fromTextArray(
            headers: const ['Test', 'Duration (ms)', 'Duration (s)'],

            data: slowestTests
                .map(
                  (test) => [
                    test.name,
                    test.duration.toString(),
                    (test.duration / 1000).toStringAsFixed(2),
                  ],
                )
                .toList(),
          ),

          pw.SizedBox(height: 20),

          pw.Header(level: 1, text: 'Pass Rate Trend'),

          pw.TableHelper.fromTextArray(
            headers: const ['Run', 'Passed', 'Failed', 'Pass Rate %'],

            data: history.asMap().entries.map((entry) {
              final item = entry.value;

              final passRate = item.totalTests == 0
                  ? 0
                  : (item.passedTests / item.totalTests) * 100;

              return [
                '${entry.key + 1}',
                '${item.passedTests}',
                '${item.failedTests}',
                passRate.toStringAsFixed(1),
              ];
            }).toList(),
          ),
        ],
      ),
    );

    // --------------------------------------------------
    // PAGE 3 - HISTORY
    // --------------------------------------------------

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 1, text: 'Test History'),

          pw.TableHelper.fromTextArray(
            headers: const ['Date', 'Tests', 'Passed', 'Failed'],

            data: history
                .map(
                  (item) => [
                    item.date,
                    '${item.totalTests}',
                    '${item.passedTests}',
                    '${item.failedTests}',
                  ],
                )
                .toList(),
          ),
        ],
      ),
    );

    return pdf;
  }

  static Future<pw.Document> generateHistoryReport(HistoryItem report) async {
    final pdf = pw.Document();

    final passRate = report.totalTests == 0
        ? 0
        : (report.passedTests / report.totalTests) * 100;

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          // --------------------------------------------------
          // BRANDING
          // --------------------------------------------------

          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'SYYNI QA',
                style: pw.TextStyle(
                  fontSize: 34,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.Text(
                'Automated Quality Assurance Platform',
                style: const pw.TextStyle(fontSize: 14),
              ),

              pw.Divider(),
            ],
          ),

          pw.SizedBox(height: 20),

          pw.Text(
            'Test Execution Report',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),

          pw.SizedBox(height: 20),

          pw.Container(
            padding: const pw.EdgeInsets.all(10),

            decoration: pw.BoxDecoration(border: pw.Border.all()),

            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,

              children: [
                pw.Text(
                  'EXECUTIVE SUMMARY',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                pw.SizedBox(height: 10),

                pw.Text('Total Tests: ${report.totalTests}'),

                pw.Text('Passed Tests: ${report.passedTests}'),

                pw.Text('Failed Tests: ${report.failedTests}'),

                pw.Text('Pass Rate: ${passRate.toStringAsFixed(1)}%'),

                pw.Text(
                  'Execution Status: '
                  '${report.failedTests == 0 ? 'PASSED' : 'FAILED'}',
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          // --------------------------------------------------
          // REPORT INFO
          // --------------------------------------------------
          pw.Text('Source: ${report.source}'),

          pw.Text('Test Type: ${report.testType}'),

          pw.Text('Date: ${report.date}'),

          pw.Text('Tests: ${report.totalTests}'),

          pw.Text('Passed: ${report.passedTests}'),

          pw.Text('Failed: ${report.failedTests}'),

          pw.Text('Pass Rate: ${passRate.toStringAsFixed(1)}%'),

          pw.Text('Duration: ${(report.duration / 1000).toStringAsFixed(1)} s'),

          pw.SizedBox(height: 20),

          // --------------------------------------------------
          // FAILED TESTS
          // --------------------------------------------------
          pw.Header(level: 1, text: 'Failed Tests'),

          if (report.failedTestsDetails.isEmpty) pw.Text('No failed tests'),

          ...report.failedTestsDetails.map(
            (test) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 10),

              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,

                children: [
                  pw.Text(
                    test['name']?.toString() ?? 'Unknown Test',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),

                  if (test['testType'] != null)
                    pw.Text('Type: ${test['testType']}'),

                  pw.SizedBox(height: 4),

                  pw.Text(test['error']?.toString() ?? 'Unknown error'),

                  pw.Divider(),
                ],
              ),
            ),
          ),

          pw.SizedBox(height: 20),

          // --------------------------------------------------
          // SLOWEST TESTS
          // --------------------------------------------------
          pw.Header(level: 1, text: 'Slowest Tests'),

          if (report.slowestTests.isEmpty)
            pw.Text('No execution data available'),

          ...report.slowestTests.map(
            (test) => pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

              children: [
                pw.Expanded(
                  child: pw.Text(
                    '${test['name']}'
                    '${test['type'] != null ? ' (${test['type']})' : ''}',
                  ),
                ),

                pw.Text(
                  '${((test['duration'] ?? 0) / 1000).toStringAsFixed(1)} s',
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return pdf;
  }
}
