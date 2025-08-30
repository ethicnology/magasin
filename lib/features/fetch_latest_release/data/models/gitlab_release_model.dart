import 'package:dart_mappable/dart_mappable.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/asset_entity.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/release_entity.dart';
import 'package:magasin/features/fetch_latest_release/data/models/gitlab_user_model.dart';
import 'package:magasin/features/fetch_latest_release/data/models/gitlab_asset_model.dart';

part 'gitlab_release_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class GitLabReleaseModel with GitLabReleaseModelMappable {
  final String name;
  final String tagName;
  final String description;
  final DateTime createdAt;
  final DateTime releasedAt;
  final bool upcomingRelease;
  final GitLabUserModel author;
  final String commitPath;
  final String tagPath;
  final GitLabAssetsModel assets;

  const GitLabReleaseModel({
    required this.name,
    required this.tagName,
    required this.description,
    required this.createdAt,
    required this.releasedAt,
    required this.upcomingRelease,
    required this.author,
    required this.commitPath,
    required this.tagPath,
    required this.assets,
  });

  ReleaseEntity toEntity() {
    final allAssets = <AssetEntity>[];

    // Add source archives
    for (final source in assets.sources) {
      allAssets.add(source.toEntity(name));
    }

    // Add release links (APKs, etc.)
    for (final link in assets.links) {
      allAssets.add(link.toEntity());
    }

    return ReleaseEntity(
      platform: PlatformType.gitlab,
      id: tagName.hashCode,
      name: name,
      tagName: tagName,
      body: description,
      publishedAt: releasedAt,
      htmlUrl: 'https://gitlab.com$tagPath',
      author: author.toEntity(),
      assets: allAssets,
    );
  }
}
