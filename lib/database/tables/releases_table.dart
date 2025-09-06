import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:magasin/database/database.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/asset_entity.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/release_entity.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/user_entity.dart';

@DataClassName('ReleaseRow')
class Releases extends Table {
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // Primary Keys: commit, tag, platform
  TextColumn get commit => text()();
  TextColumn get tag => text()();
  TextColumn get platform => textEnum<ReleaseProviderColumn>()();

  // Release basic info
  TextColumn get name => text()();
  TextColumn get description => text()();

  TextColumn get url => text()();
  DateTimeColumn get publishedAt => dateTime()();

  // Project info
  TextColumn get organization => text()();
  TextColumn get project => text()();

  // Author info (embedded)
  IntColumn get authorId => integer()();
  TextColumn get authorUsername => text()();
  TextColumn get authorProfileUrl => text()();

  // List of assets JSON encoded
  TextColumn get assets => text()();

  @override
  // there should be no duplicates entry for the same commit and tag on the same platform
  // but we could have the same commit and tag on different platforms
  Set<Column<Object>> get primaryKey => {commit, tag, platform};
}

enum ReleaseProviderColumn {
  github,
  gitlab;

  static ReleaseProviderColumn fromEntity(ReleaseProvider entity) {
    switch (entity) {
      case ReleaseProvider.github:
        return ReleaseProviderColumn.github;
      case ReleaseProvider.gitlab:
        return ReleaseProviderColumn.gitlab;
    }
  }

  ReleaseProvider toEntity() {
    switch (this) {
      case ReleaseProviderColumn.github:
        return ReleaseProvider.github;
      case ReleaseProviderColumn.gitlab:
        return ReleaseProvider.gitlab;
    }
  }
}

extension ReleaseEntityExtensions on ReleaseEntity {
  ReleasesCompanion toCompanion() {
    final encodedAssets = json.encode(
      assets.map((asset) => asset.toMap()).toList(),
    );

    return ReleasesCompanion(
      name: Value(name),
      tag: Value(tag),
      platform: Value(ReleaseProviderColumn.fromEntity(platform)),
      publishedAt: Value(publishedAt),
      url: Value(url.toString()),
      organization: Value(organization),
      project: Value(project),
      authorId: Value(author.id),
      authorUsername: Value(author.username),
      authorProfileUrl: Value(author.profileUrl.toString()),
      description: Value(description),
      commit: Value(commit),
      assets: Value(encodedAssets),
    );
  }
}

extension ReleaseDataExtensions on ReleaseRow {
  ReleaseEntity toEntity() {
    final decoded = json.decode(assets) as List<dynamic>;
    final decodedAssets = decoded
        .map((e) => AssetEntity.fromMap(e as Map<String, dynamic>))
        .toList();

    return ReleaseEntity(
      name: name,
      tag: tag,
      platform: platform.toEntity(),
      publishedAt: publishedAt,
      url: Uri.parse(url),
      description: description,
      commit: commit,
      assets: decodedAssets,
      organization: organization,
      project: project,
      author: UserEntity(
        id: authorId,
        username: authorUsername,
        avatarUrl: Uri.parse(authorProfileUrl),
        profileUrl: Uri.parse(authorProfileUrl),
      ),
    );
  }
}
