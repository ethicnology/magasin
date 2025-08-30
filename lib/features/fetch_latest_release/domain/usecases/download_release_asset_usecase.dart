import 'package:magasin/features/fetch_latest_release/domain/repositories/github_repository.dart';
import 'package:magasin/features/fetch_latest_release/domain/repositories/gitlab_repository.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/release_entity.dart';

class DownloadReleaseAssetUseCase {
  final GitHubRepository githubRepository;
  final GitLabRepository gitlabRepository;

  DownloadReleaseAssetUseCase({
    required this.githubRepository,
    required this.gitlabRepository,
  });

  Future<void> call(
    String downloadUrl,
    String fileName,
    PlatformType platform,
  ) async {
    if (downloadUrl.isEmpty) {
      throw Exception('Download URL cannot be empty');
    }

    if (fileName.isEmpty) {
      throw Exception('File name cannot be empty');
    }

    switch (platform) {
      case PlatformType.github:
        return await githubRepository.downloadAsset(downloadUrl, fileName);
      case PlatformType.gitlab:
        return await gitlabRepository.downloadAsset(downloadUrl, fileName);
    }
  }
}
