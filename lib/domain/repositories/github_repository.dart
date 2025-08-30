import '../entities/github_release.dart';

class GitHubRepository {
  Future<GitHubRelease> getLatestRelease(String githubUrl) {
    throw UnimplementedError('Must be implemented by concrete repository');
  }

  Future<void> downloadAsset(String downloadUrl, String fileName) {
    throw UnimplementedError('Must be implemented by concrete repository');
  }
}
