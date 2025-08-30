import '../entities/github_release.dart';
import '../repositories/github_repository.dart';

class GetLatestRelease {
  final GitHubRepository repository;

  GetLatestRelease({required this.repository});

  Future<GitHubRelease> call(String githubUrl) async {
    if (githubUrl.isEmpty) {
      throw Exception('GitHub URL cannot be empty');
    }

    if (!githubUrl.contains('github.com')) {
      throw Exception('Please provide a valid GitHub repository URL');
    }

    return await repository.getLatestRelease(githubUrl);
  }
}
