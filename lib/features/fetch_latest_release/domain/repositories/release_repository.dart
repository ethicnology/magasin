import 'package:magasin/features/fetch_latest_release/domain/entities/asset_entity.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/release_entity.dart';
import 'package:magasin/features/fetch_latest_release/data/datasources/github_datasource.dart';
import 'package:magasin/features/fetch_latest_release/data/datasources/gitlab_datasource.dart';
import 'package:magasin/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ReleaseRepository {
  final GitHubDatasource _githubDatasource;
  final GitLabDatasource _gitlabDatasource;

  ReleaseRepository({
    required GitHubDatasource githubDatasource,
    required GitLabDatasource gitlabDatasource,
  }) : _githubDatasource = githubDatasource,
       _gitlabDatasource = gitlabDatasource;

  /// Fetch the latest release from GitHub or GitLab based on the URL
  Future<ReleaseEntity> getLatestRelease(Uri url) async {
    try {
      ReleaseEntity release;
      if (url.isGitHub) {
        final result = extractOwnerAndRepo(url);
        final model = await _githubDatasource.getLatestRelease(
          result.owner,
          result.repo,
        );
        final commitHash = await _githubDatasource.getCommitHashForTag(
          result.owner,
          result.repo,
          model.tagName,
        );
        release = model.toEntity(commitHash: commitHash);
      } else if (url.isGitLab) {
        final result = extractOwnerAndRepo(url);
        final model = await _gitlabDatasource.getLatestRelease(
          result.owner,
          result.repo,
        );
        release = model.toEntity();
      } else {
        throw Exception('Unsupported platform: ${url.host}');
      }

      return release;
    } catch (e) {
      throw Exception('Failed to get latest release: $e');
    }
  }

  Future<void> downloadAsset(AssetEntity asset) async {
    try {
      final uri = asset.url;
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch download URL');
      }
    } catch (e) {
      throw Exception('Failed to download asset: $e');
    }
  }
}
