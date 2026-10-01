import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../models/test_history.dart';
import '../services/report_service.dart';
import '../services/pdf_report_service.dart';
import '../theme/app_colors.dart';
import 'report_details_screen.dart';

class TestHistoryScreen extends StatefulWidget {
  const TestHistoryScreen({super.key});

  @override
  State<TestHistoryScreen> createState() => _TestHistoryScreenState();
}

class _TestHistoryScreenState extends State<TestHistoryScreen> {
  String selectedSource = 'all';
  late Future<List<HistoryItem>> historyFuture;
  final Set<int> selectedReports = {};

  @override
  void initState() {
    super.initState();

    historyFuture = ReportService().loadHistory(source: selectedSource);
  }

  void _toggleAll(List<HistoryItem> history, bool? value) {
    setState(() {
      selectedReports.clear();

      if (value == true) {
        selectedReports.addAll(history.map((e) => e.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),

      appBar: AppBar(
        backgroundColor: Colors.deepPurple,

        title: const Row(
          children: [
            Icon(Icons.assessment, color: Colors.white),

            SizedBox(width: 12),

            Text('Reports'),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        title: const Row(
          children: [
            Icon(Icons.assessment, color: Colors.white),
            SizedBox(width: 12),
            Text('Reports'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                historyFuture = ReportService().loadHistory(
                  source: selectedSource,
                );
              });
            },
          ),
        ],
      ),

      body: FutureBuilder<List<HistoryItem>>(
        future: historyFuture,

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

          final history = List<HistoryItem>.from(snapshot.data!);

          history.sort((a, b) => b.id.compareTo(a.id));

          final totalRuns = history.length;

          final totalPassed = history.fold(
            0,
            (sum, item) => sum + item.passedTests,
          );

          final totalFailed = history.fold(
            0,
            (sum, item) => sum + item.failedTests,
          );

          final successRate = totalPassed + totalFailed == 0
              ? '0'
              : ((totalPassed / (totalPassed + totalFailed)) * 100)
                    .toStringAsFixed(1);

          return Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'TEST REPORTS',
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

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
                        DropdownMenuItem(value: 'local', child: Text('Local')),

                        DropdownMenuItem(
                          value: 'github',
                          child: Text('GitHub'),
                        ),

                        DropdownMenuItem(value: 'all', child: Text('All')),
                      ],

                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          selectedSource = value;

                          selectedReports.clear();

                          historyFuture = ReportService().loadHistory(
                            source: selectedSource,
                          );
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const SizedBox(height: 20),

                Row(
                  children: [
                    _buildSummaryCard(
                      context,
                      'Runs',
                      totalRuns.toString(),
                      Colors.blue,
                    ),

                    _buildSummaryCard(
                      context,
                      'Passed',
                      totalPassed.toString(),
                      Colors.green,
                    ),

                    _buildSummaryCard(
                      context,
                      'Failed',
                      totalFailed.toString(),
                      Colors.red,
                    ),

                    _buildSummaryCard(
                      context,
                      'Success',
                      '$successRate%',
                      Colors.orange,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Generate PDF Report'),

                  onPressed: () async {
                    if (selectedReports.length != 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Select exactly one report'),
                        ),
                      );

                      return;
                    }

                    final selectedReport = history.firstWhere(
                      (item) => selectedReports.contains(item.id),
                    );

                    final pdf = await PdfReportService.generateHistoryReport(
                      selectedReport,
                    );

                    await Printing.layoutPdf(
                      onLayout: (format) async => pdf.save(),
                    );
                  },
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),

                      onPressed: selectedReports.isEmpty
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return AlertDialog(
                                    title: const Text('Delete Reports'),
                                    content: Text(
                                      'Delete ${selectedReports.length} selected report(s)?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),

                                      ElevatedButton(
                                        onPressed: () async {
                                          await ReportService()
                                              .deleteHistoryRuns(
                                                selectedReports.toList(),
                                              );

                                          Navigator.of(dialogContext).pop();

                                          setState(() {
                                            selectedReports.clear();

                                            historyFuture = ReportService()
                                                .loadHistory(
                                                  source: selectedSource,
                                                );
                                          });
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                    ),

                    Text('${selectedReports.length} selected'),
                  ],
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        AppColors.card(context),
                      ),

                      columns: [
                        DataColumn(
                          label: Checkbox(
                            value:
                                history.isNotEmpty &&
                                selectedReports.length == history.length,
                            onChanged: (value) {
                              _toggleAll(history, value);
                            },
                          ),
                        ),

                        const DataColumn(label: Text('Source')),

                        const DataColumn(
                          label: Icon(Icons.visibility, color: Colors.teal),
                        ),

                        DataColumn(
                          label: Text(
                            'Date',
                            style: TextStyle(color: AppColors.text(context)),
                          ),
                        ),

                        DataColumn(
                          label: Text(
                            'Tests',
                            style: TextStyle(color: AppColors.text(context)),
                          ),
                        ),

                        const DataColumn(
                          label: Text(
                            'Passed',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),

                        const DataColumn(
                          label: Text(
                            'Failed',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),

                        const DataColumn(
                          label: Text(
                            'Success %',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],

                      rows: history.map((item) {
                        final runRate = item.totalTests == 0
                            ? '0'
                            : ((item.passedTests / item.totalTests) * 100)
                                  .toStringAsFixed(1);

                        return DataRow(
                          selected: selectedReports.contains(item.id),

                          cells: [
                            DataCell(
                              Checkbox(
                                value: selectedReports.contains(item.id),
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedReports.add(item.id);
                                    } else {
                                      selectedReports.remove(item.id);
                                    }
                                  });
                                },
                              ),
                            ),

                            DataCell(
                              Text(
                                item.source == 'github'
                                    ? '☁ GitHub'
                                    : '💻 Local',
                              ),
                            ),

                            DataCell(
                              const Icon(Icons.visibility, color: Colors.teal),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ReportDetailsScreen(report: item),
                                  ),
                                );
                              },
                            ),

                            DataCell(
                              Text(
                                item.date,
                                style: TextStyle(
                                  color: AppColors.text(context),
                                ),
                              ),
                            ),

                            DataCell(
                              Text(
                                item.totalTests.toString(),
                                style: TextStyle(
                                  color: AppColors.text(context),
                                ),
                              ),
                            ),

                            DataCell(
                              Text(
                                item.passedTests.toString(),
                                style: const TextStyle(color: Colors.green),
                              ),
                            ),

                            DataCell(
                              Text(
                                item.failedTests.toString(),
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),

                            DataCell(
                              Text(
                                '$runRate%',
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(
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
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(title, style: TextStyle(color: AppColors.text(context))),
            ],
          ),
        ),
      ),
    );
  }
}
