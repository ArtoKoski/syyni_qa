import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/test_result.dart';
import '../models/test_history.dart';
import '../models/failed_test.dart';
import '../models/test_execution.dart';
import '../models/build_info.dart';

class ReportService {
  // Enable Mock Mode with true value and disable with false value
  static bool mockMode = true;
  static String baseUrl = 'http://10.6.128.114:3000';
  static String get playwrightReportUrl => '$baseUrl/report/index.html';

  Future<BuildInfo> loadBuildInfo() async {
    final response = await http.get(Uri.parse('$baseUrl/api/build-info'));

    if (response.statusCode != 200) {
      throw Exception('Build info not available');
    }

    final data = jsonDecode(response.body);

    return BuildInfo.fromJson(data);
  }

  Future<List<HistoryItem>> loadHistory({String source = 'local'}) async {
    if (mockMode) {
      return [
        HistoryItem(
          id: 1,
          date: '2026-09-28',
          totalTests: 50,
          passedTests: 48,
          failedTests: 2,
          duration: 22000,
          source: 'github',
          testType: 'UI',
          failedTestsDetails: [],
          slowestTests: [],
        ),

        HistoryItem(
          id: 2,
          date: '2026-09-29',
          totalTests: 51,
          passedTests: 50,
          failedTests: 1,
          duration: 25000,
          source: 'local',
          testType: 'API',
          failedTestsDetails: [],
          slowestTests: [],
        ),

        HistoryItem(
          id: 3,
          date: '2026-09-30',
          totalTests: 52,
          passedTests: 49,
          failedTests: 3,
          duration: 28000,
          source: 'github',
          testType: 'Mixed',
          failedTestsDetails: [],
          slowestTests: [],
        ),
      ];
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/history?source=$source'),
    );

    if (response.statusCode != 200) {
      throw Exception('Historian haku epäonnistui (${response.statusCode})');
    }

    final data = jsonDecode(response.body);

    return (data as List).map((e) => HistoryItem.fromJson(e)).toList();
  }

  Future<void> deleteHistoryRuns(List<int> ids) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/history/delete'),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({'ids': ids}),
    );

    if (response.statusCode != 200) {
      throw Exception('Poistaminen epäonnistui');
    }
  }

  Future<TestResult> loadResults({String source = 'local'}) async {
    if (mockMode) {
      return TestResult(
        totalTests: 52,
        passedTests: 49,
        failedTests: 3,
        lastRun: '2026-10-01 12:00',
      );
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/results?source=$source'),
    );

    if (response.statusCode != 200) {
      throw Exception('Tulosten haku epäonnistui (${response.statusCode})');
    }

    final data = jsonDecode(response.body);

    if (response.body.trim().isEmpty) {
      return TestResult(
        totalTests: 0,
        passedTests: 0,
        failedTests: 0,
        lastRun: 'Ei saatavilla',
      );
    }

    return TestResult(
      totalTests: data['totalTests'] ?? 0,
      passedTests: data['passedTests'] ?? 0,
      failedTests: data['failedTests'] ?? 0,
      lastRun: data['lastRun'] ?? 'Ei saatavilla',
    );
  }

  Future<List<FailedTest>> loadFailedTests({String source = 'local'}) async {
    if (mockMode) {
      return [
        FailedTest(name: 'Login Test', error: 'Timeout waiting for element'),

        FailedTest(name: 'Checkout Test', error: 'Expected status 200'),
      ];
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/results/failed-tests?source=$source'),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final data = jsonDecode(response.body);

    return (data as List).map((e) => FailedTest.fromJson(e)).toList();
  }

  Future<List<TestExecution>> loadSlowestTests({String source = 'all'}) async {
    if (mockMode) {
      return [
        TestExecution(name: 'Logo Animation', duration: 2700),

        TestExecution(name: 'Checkout Flow', duration: 2200),

        TestExecution(name: 'Search Test', duration: 1800),
      ];
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/results/slowest-tests?source=$source'),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final data = jsonDecode(response.body);

    return (data as List).map((e) => TestExecution.fromJson(e)).toList();
  }

  Future<void> runTests() async {
    final response = await http.post(Uri.parse('$baseUrl/api/run-tests'));

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  Future<void> runGitHubTests() async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/run-github-tests'),
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }
}
