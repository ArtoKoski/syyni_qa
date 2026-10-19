class BuildInfo {
  final String branch;
  final String commit;
  final String author;
  final String message;
  final String buildDate;

  const BuildInfo({
    required this.branch,
    required this.commit,
    required this.author,
    required this.message,
    required this.buildDate,
  });

  factory BuildInfo.fromJson(Map<String, dynamic> json) {
    return BuildInfo(
      branch: json['branch'] ?? 'unknown',
      commit: json['commit'] ?? 'unknown',
      author: json['author'] ?? 'unknown',
      message: json['message'] ?? 'unknown',
      buildDate: json['buildDate'] ?? 'unknown',
    );
  }
}
