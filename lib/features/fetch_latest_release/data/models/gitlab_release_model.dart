import 'package:dart_mappable/dart_mappable.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/asset_entity.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/release_entity.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/user_entity.dart';

part 'gitlab_release_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class GitlabReleaseModel with GitlabReleaseModelMappable {
  final String name;
  final String tagName;
  final String description;
  final DateTime createdAt;
  final DateTime releasedAt;
  final bool upcomingRelease;
  final Author author;
  final Commit commit;
  final String commitPath;
  final String tagPath;
  final Assets assets;
  final List<dynamic> evidences;

  GitlabReleaseModel({
    required this.name,
    required this.tagName,
    required this.description,
    required this.createdAt,
    required this.releasedAt,
    required this.upcomingRelease,
    required this.author,
    required this.commit,
    required this.commitPath,
    required this.tagPath,
    required this.assets,
    this.evidences = const [],
  });

  ReleaseEntity toEntity() {
    // Extract organization and project name from tagPath
    // Example: /fdroid/fdroidclient/-/tags/1.23.0
    final pathSegments = tagPath.split('/').where((s) => s.isNotEmpty).toList();
    final organization = pathSegments.isNotEmpty ? pathSegments[0] : '';
    final project = pathSegments.length > 1 ? pathSegments[1] : '';

    // Combine all assets (sources + links)
    final allAssets = <AssetEntity>[];

    // Add release links (APKs, etc.)
    for (final link in assets.links) {
      allAssets.add(AssetEntity(name: link.name, url: link.url));
    }

    return ReleaseEntity(
      platform: ReleaseProvider.gitlab,
      name: name,
      tag: tagName,
      description: description,
      publishedAt: releasedAt,
      url: Uri.parse('https://gitlab.com$tagPath'),
      commit: commit.id,
      author: author.toEntity(),
      assets: allAssets,
      organization: organization,
      project: project,
    );
  }
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Assets with AssetsMappable {
  final int count;
  final List<Source> sources;
  final List<Link> links;

  Assets({required this.count, required this.sources, required this.links});
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Link with LinkMappable {
  final int id;
  final String name;
  final Uri url;
  final Uri directAssetUrl;
  final String linkType;

  Link({
    required this.id,
    required this.name,
    required this.url,
    required this.directAssetUrl,
    required this.linkType,
  });
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Source with SourceMappable {
  final String format;
  final Uri url;

  Source({required this.format, required this.url});
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Author with AuthorMappable {
  final int id;
  final String username;
  final String publicEmail;
  final String name;
  final String state;
  final bool locked;
  final Uri avatarUrl;
  final Uri webUrl;

  Author({
    required this.id,
    required this.username,
    required this.publicEmail,
    required this.name,
    required this.state,
    required this.locked,
    required this.avatarUrl,
    required this.webUrl,
  });

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      avatarUrl: avatarUrl,
      profileUrl: webUrl,
    );
  }
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Commit with CommitMappable {
  final String id;
  final String shortId;
  final DateTime createdAt;
  final List<String> parentIds;
  final String title;
  final String message;
  final String authorName;
  final String authorEmail;
  final DateTime authoredDate;
  final String committerName;
  final String committerEmail;
  final DateTime committedDate;
  final Uri webUrl;

  Commit({
    required this.id,
    required this.shortId,
    required this.createdAt,
    required this.parentIds,
    required this.title,
    required this.message,
    required this.authorName,
    required this.authorEmail,
    required this.authoredDate,
    required this.committerName,
    required this.committerEmail,
    required this.committedDate,
    required this.webUrl,
  });
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Links with LinksMappable {
  final Uri closedIssuesUrl;
  final Uri closedMergeRequestsUrl;
  final Uri mergedMergeRequestsUrl;
  final Uri openedIssuesUrl;
  final Uri openedMergeRequestsUrl;
  final Uri self;

  Links({
    required this.closedIssuesUrl,
    required this.closedMergeRequestsUrl,
    required this.mergedMergeRequestsUrl,
    required this.openedIssuesUrl,
    required this.openedMergeRequestsUrl,
    required this.self,
  });
}
