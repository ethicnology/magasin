import 'package:url_launcher/url_launcher.dart';
import '../entities/github_release.dart';
import '../../data/datasources/github_datasource.dart';

class GitHubRepository {
  final GitHubDatasource datasource;

  GitHubRepository({required this.datasource});

  Future<GitHubRelease> getLatestRelease(String githubUrl) async {
    try {
      final ownerRepo = datasource.extractOwnerAndRepo(githubUrl);
      final parts = ownerRepo.split('/');
      final owner = parts[0];
      final repo = parts[1];
      
      final releaseModel = await datasource.getLatestRelease(owner, repo);
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
