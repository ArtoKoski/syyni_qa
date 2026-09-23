class TestExecution {
  final String name;
  final int duration;

  TestExecution({required this.name, required this.duration});

  factory TestExecution.fromJson(Map<String, dynamic> json) {
    return TestExecution(
      name: json['name'] ?? '',
      duration: json['duration'] ?? 0,
    );
  }
}
