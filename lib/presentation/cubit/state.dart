import 'package:dart_mappable/dart_mappable.dart';
import '../../domain/entities/github_release_entity.dart';

part 'state.mapper.dart';

enum GitHubReleaseStatus {
  initial,
  loading,
  loaded,
  error,
  assetDownloading,
  assetDownloadSuccess,
  assetDownloadError,
}

@MappableClass()
class GitHubReleaseState with GitHubReleaseStateMappable {
  final GitHubReleaseStatus status;
  final GitHubReleaseEntity? release;
  final String? errorMessage;
  final String? downloadingAssetName;

  const GitHubReleaseState({
    required this.status,
    this.release,
    this.errorMessage,
    this.downloadingAssetName,
  });

  const GitHubReleaseState.initial()
    : status = GitHubReleaseStatus.initial,
      release = null,
      errorMessage = null,
      downloadingAssetName = null;

  const GitHubReleaseState.loading()
    : status = GitHubReleaseStatus.loading,
      release = null,
      errorMessage = null,
      downloadingAssetName = null;

  GitHubReleaseState.loaded(GitHubReleaseEntity this.release)
    : status = GitHubReleaseStatus.loaded,
      errorMessage = null,
      downloadingAssetName = null;

  const GitHubReleaseState.error(String message)
    : status = GitHubReleaseStatus.error,
      release = null,
      errorMessage = message,
      downloadingAssetName = null;

  GitHubReleaseState.assetDownloading(
    GitHubReleaseEntity this.release,
    String assetName,
  ) : status = GitHubReleaseStatus.assetDownloading,
      errorMessage = null,
      downloadingAssetName = assetName;

  GitHubReleaseState.assetDownloadSuccess(
    GitHubReleaseEntity this.release,
    String assetName,
  ) : status = GitHubReleaseStatus.assetDownloadSuccess,
      errorMessage = null,
      downloadingAssetName = assetName;

  GitHubReleaseState.assetDownloadError(
    GitHubReleaseEntity this.release,
    String error,
  ) : status = GitHubReleaseStatus.assetDownloadError,
      errorMessage = error,
      downloadingAssetName = null;
}
