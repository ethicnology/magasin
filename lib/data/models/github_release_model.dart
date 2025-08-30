import 'package:dart_mappable/dart_mappable.dart';
import 'github_user_model.dart';
import 'github_asset_model.dart';
import '../../domain/entities/github_release.dart';

part 'github_release_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class GitHubReleaseModel with GitHubReleaseModelMappable {
  final String url;
  final String assetsUrl;
  final String uploadUrl;
  final String htmlUrl;
  final int id;
  final GitHubUserModel author;
  final String nodeId;
  final String tagName;
  final String targetCommitish;
  final String name;
  final bool draft;
  final bool immutable;
  final bool prerelease;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;
  final List<GitHubAssetModel> assets;
  final String tarballUrl;
  final String zipballUrl;
  final String body;

  const GitHubReleaseModel({
    required this.url,
    required this.assetsUrl,
    required this.uploadUrl,
    required this.htmlUrl,
    required this.id,
    required this.author,
    required this.nodeId,
    required this.tagName,
    required this.targetCommitish,
    required this.name,
    required this.draft,
    required this.immutable,
    required this.prerelease,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.assets,
    required this.tarballUrl,
    required this.zipballUrl,
    required this.body,
  });

  GitHubRelease toEntity() {
    return GitHubRelease(
      id: id,
      htmlUrl: htmlUrl,
      author: author.toEntity(),
      tagName: tagName,
      name: name,
      draft: draft,
      prerelease: prerelease,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      publishedAt: DateTime.parse(publishedAt),
      assets: assets.map((asset) => asset.toEntity()).toList(),
      body: body,
    );
  }
}
