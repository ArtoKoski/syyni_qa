import '../models/build_info.dart';

class GithubMetadataParser {
  static BuildInfo parse(Map<String, dynamic> json) {
    final commit = json['config']?['metadata']?['gitCommit'];

    return BuildInfo(
      branch: commit?['branch'] ?? 'Unknown',
      commit: commit?['shortHash'] ?? 'Unknown',
      author: commit?['author']?['name'] ?? 'Unknown',
      message: commit?['subject'] ?? '',
    );
  }
}
