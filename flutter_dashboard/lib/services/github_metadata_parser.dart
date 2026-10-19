import '../models/build_info.dart';

class GithubMetadataParser {
  static BuildInfo parse(Map<String, dynamic> json) {
    if (json.containsKey('branch')) {
      return BuildInfo(
        branch: json['branch'] ?? 'Unknown',
        commit: json['commit'] ?? 'Unknown',
        author: json['author'] ?? 'Unknown',
        message: json['message'] ?? '',
        buildDate: json['buildDate'] ?? 'Unknown',
      );
    }

    final commit = json['config']?['metadata']?['gitCommit'];

    return BuildInfo(
      branch: commit?['branch'] ?? 'Unknown',
      commit: commit?['shortHash'] ?? 'Unknown',
      author: commit?['author']?['name'] ?? 'Unknown',
      message: commit?['subject'] ?? '',
      buildDate: 'Unknown',
    );
  }
}
