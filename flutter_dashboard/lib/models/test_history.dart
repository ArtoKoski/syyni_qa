class HistoryItem {
  final int id;
  final String date;
  final int totalTests;
  final int passedTests;
  final int failedTests;
  final int duration;

  /// local | github
  final String source;

  /// API | UI | Mixed | Unknown
  final String testType;

  final List<Map<String, dynamic>> failedTestsDetails;
  final List<Map<String, dynamic>> slowestTests;

  HistoryItem({
    required this.id,
    required this.date,
    required this.totalTests,
    required this.passedTests,
    required this.failedTests,
    required this.duration,
    required this.source,
    required this.testType,
    required this.failedTestsDetails,
    required this.slowestTests,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      totalTests: json['totalTests'] ?? 0,
      passedTests: json['passedTests'] ?? 0,
      failedTests: json['failedTests'] ?? 0,
      duration: json['duration'] ?? 0,

      source: json['source']?.toString() ?? 'local',

      testType: json['testType']?.toString() ?? 'Unknown',

      failedTestsDetails:
          (json['failedTestsDetails'] as List?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          [],

      slowestTests:
          (json['slowestTests'] as List?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'totalTests': totalTests,
      'passedTests': passedTests,
      'failedTests': failedTests,
      'duration': duration,
      'source': source,
      'testType': testType,
      'failedTestsDetails': failedTestsDetails,
      'slowestTests': slowestTests,
    };
  }
}
