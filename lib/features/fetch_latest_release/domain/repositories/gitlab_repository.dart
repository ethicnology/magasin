import 'package:magasin/features/fetch_latest_release/domain/entities/release_entity.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:magasin/features/fetch_latest_release/data/datasources/gitlab_datasource.dart';

class GitLabRepository {
  final GitLabDatasource datasource;

  GitLabRepository({required this.datasource});

  Future<ReleaseEntity> getLatestRelease(Uri gitlabUrl) async {
    try {
      final projectPath = datasource.extractProjectPath(gitlabUrl.toString());
      final releaseModel = await datasource.getLatestRelease(projectPath);
      return releaseModel.toEntity();
    } catch (e) {
      throw Exception('Failed to get latest release: $e');
    }
  }

  Future<void> downloadAsset(String downloadUrl, String fileName) async {
    try {
      final uri = Uri.parse(downloadUrl);
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
