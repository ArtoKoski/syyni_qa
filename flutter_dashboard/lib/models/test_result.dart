class TestResult {
  final int totalTests;
  final int passedTests;
  final int failedTests;
  final String lastRun;

  TestResult({
    required this.totalTests,
    required this.passedTests,
    required this.failedTests,
    required this.lastRun,
  });
}
