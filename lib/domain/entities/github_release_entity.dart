import 'github_user_entity.dart';
import 'github_asset_entity.dart';

class GitHubReleaseEntity {
  final int id;
  final String htmlUrl;
  final GitHubUserEntity author;
  final String tagName;
  final String name;
  final bool draft;
  final bool prerelease;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
  final List<GitHubAssetEntity> assets;
  final String body;

  const GitHubReleaseEntity({
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
