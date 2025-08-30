import 'package:magasin/features/fetch_latest_release/domain/entities/release_entity.dart';
import 'package:magasin/features/fetch_latest_release/domain/repositories/github_repository.dart';
import 'package:magasin/features/fetch_latest_release/domain/repositories/gitlab_repository.dart';

class GetReleaseUseCase {
  final GitHubRepository githubRepository;
  final GitLabRepository gitlabRepository;

  GetReleaseUseCase({
    required this.githubRepository,
    required this.gitlabRepository,
  });

  Future<ReleaseEntity> call(Uri url) async {
    final urlString = url.toString();

    if (urlString.contains('github.com')) {
      final githubRelease = await githubRepository.getLatestRelease(url);
      return githubRelease;
    } else if (urlString.contains('gitlab.com')) {
      final gitlabRelease = await gitlabRepository.getLatestRelease(url);
      return gitlabRelease;
    } else {
      throw Exception(
        'Unsupported platform. Only GitHub and GitLab are supported.',
      );
    }
  }
}
