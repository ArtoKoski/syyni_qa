class BuildInfo {
  final String branch;
  final String commit;
  final String author;
  final String message;

  const BuildInfo({
    required this.branch,
    required this.commit,
    required this.author,
    required this.message,
  });
}
