class FailedTest {
  final String name;
  final String error;

  FailedTest({required this.name, required this.error});

  factory FailedTest.fromJson(Map<String, dynamic> json) {
    return FailedTest(name: json['name'] ?? '', error: json['error'] ?? '');
  }
}
