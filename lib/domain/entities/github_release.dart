import 'github_user.dart';
import 'github_asset.dart';

class GitHubRelease {
  final int id;
  final String htmlUrl;
  final GitHubUser author;
  final String tagName;
  final String name;
  final bool draft;
  final bool prerelease;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
  final List<GitHubAsset> assets;
  final String body;

  const GitHubRelease({
    required this.id,
    required this.htmlUrl,
    required this.author,
    required this.tagName,
    required this.name,
    required this.draft,
    required this.prerelease,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.assets,
    required this.body,
  });
}
