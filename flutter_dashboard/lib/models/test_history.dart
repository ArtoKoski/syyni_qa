class HistoryItem {
  final int id;
  final String date;
  final int totalTests;
  final int passedTests;
  final int failedTests;
  final int duration;
  final String source;

  final List<dynamic> failedTestsDetails;
  final List<dynamic> slowestTests;

  HistoryItem({
    required this.id,
    required this.date,
    required this.totalTests,
    required this.passedTests,
    required this.failedTests,
    required this.duration,
    required this.failedTestsDetails,
    required this.slowestTests,
    required this.source,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      source: json['source']?.toString() ?? 'local',
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      totalTests: json['totalTests'] ?? 0,
      passedTests: json['passedTests'] ?? 0,
      failedTests: json['failedTests'] ?? 0,
      duration: json['duration'] ?? 0,
      failedTestsDetails: json['failedTestsDetails'] is List
          ? json['failedTestsDetails']
          : [],
      slowestTests: json['slowestTests'] ?? [],
    );
  }
}
