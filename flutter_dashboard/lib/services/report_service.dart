import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/test_result.dart';
import '../models/test_history.dart';
import '../models/failed_test.dart';
import '../models/test_execution.dart';

class ReportService {
  static const String baseUrl = 'http://10.6.128.122:3000';

  Future<List<HistoryItem>> loadHistory({String source = 'local'}) async {
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
    final response = await http.get(
      Uri.parse('$baseUrl/api/results?source=$source'),
    );

    if (response.statusCode != 200) {
      throw Exception('Tulosten haku epäonnistui (${response.statusCode})');
    }

    final data = jsonDecode(response.body);

    return TestResult(
      totalTests: data['totalTests'] ?? 0,
      passedTests: data['passedTests'] ?? 0,
      failedTests: data['failedTests'] ?? 0,
      lastRun: data['lastRun'] ?? 'Ei saatavilla',
    );
  }

  Future<List<FailedTest>> loadFailedTests({String source = 'local'}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/results/failed-tests'),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final data = jsonDecode(response.body);

    return (data as List).map((e) => FailedTest.fromJson(e)).toList();
  }

  Future<List<TestExecution>> loadSlowestTests({
    String source = 'local',
  }) async {
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
