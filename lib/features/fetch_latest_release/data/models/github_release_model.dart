import 'package:dart_mappable/dart_mappable.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/asset_entity.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/release_entity.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/user_entity.dart';

part 'github_release_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class GithubReleaseModel with GithubReleaseModelMappable {
  final String url;
  final Uri assetsUrl;
  final String uploadUrl;
  final String htmlUrl;
  final int id;
  final Author author;
  final String nodeId;
  final String tagName;
  final String targetCommitish;
  final String name;
  final bool draft;
  final bool immutable;
  final bool prerelease;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
  final List<Asset> assets;
  final Uri tarballUrl;
  final Uri zipballUrl;
  final String body;

  GithubReleaseModel({
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

  ReleaseEntity toEntity() {
    // Extract organization and project name from htmlUrl
    // Example: https://github.com/microsoft/vscode/releases/tag/1.85.0
    final uri = Uri.parse(htmlUrl);
    final pathSegments = uri.pathSegments;
    final organization = pathSegments.isNotEmpty ? pathSegments[0] : '';
    final project = pathSegments.length > 1 ? pathSegments[1] : '';

    return ReleaseEntity(
      platform: ReleaseProvider.github,
      name: name,
      tag: tagName,
      description: body,
      publishedAt: publishedAt,
      url: Uri.parse(htmlUrl),
      commit: targetCommitish,
      author: author.toEntity(),
      assets: assets
          .map(
            (asset) =>
                AssetEntity(name: asset.name, url: asset.browserDownloadUrl),
          )
          .toList(),
      organization: organization,
      project: project,
    );
  }
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Asset with AssetMappable {
  final Uri url;
  final int id;
  final String nodeId;
  final String name;
  final String? label;
  final Author uploader;
  final String contentType;
  final String state;
  final int size;
  final String digest;
  final int downloadCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Uri browserDownloadUrl;

  Asset({
    required this.url,
    required this.id,
    required this.nodeId,
    required this.name,
    required this.label,
    required this.uploader,
    required this.contentType,
    required this.state,
    required this.size,
    required this.digest,
    required this.downloadCount,
    required this.createdAt,
    required this.updatedAt,
    required this.browserDownloadUrl,
  });

  AssetEntity toEntity() {
    return AssetEntity(name: name, url: browserDownloadUrl);
  }
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Author with AuthorMappable {
  final String login;
  final int id;
  final String nodeId;
  final Uri avatarUrl;
  final String gravatarId;
  final Uri url;
  final Uri htmlUrl;
  final Uri followersUrl;
  final String followingUrl;
  final String gistsUrl;
  final String starredUrl;
  final Uri subscriptionsUrl;
  final Uri organizationsUrl;
  final Uri reposUrl;
  final String eventsUrl;
  final Uri receivedEventsUrl;
  final String type;
  final String userViewType;
  final bool siteAdmin;

  Author({
    required this.login,
    required this.id,
    required this.nodeId,
    required this.avatarUrl,
    required this.gravatarId,
    required this.url,
    required this.htmlUrl,
    required this.followersUrl,
    required this.followingUrl,
    required this.gistsUrl,
    required this.starredUrl,
    required this.subscriptionsUrl,
    required this.organizationsUrl,
    required this.reposUrl,
    required this.eventsUrl,
    required this.receivedEventsUrl,
    required this.type,
    required this.userViewType,
    required this.siteAdmin,
  });

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: login,
      avatarUrl: avatarUrl,
      profileUrl: htmlUrl,
    );
  }
}
