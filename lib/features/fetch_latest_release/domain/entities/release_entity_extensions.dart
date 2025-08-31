import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:magasin/database/tables/releases_table.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/asset_entity.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/release_entity.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/user_entity.dart';
import 'package:magasin/database/database.dart';

extension ReleaseEntityExtensions on ReleaseEntity {
  ReleasesCompanion toCompanion() {
    final jsonAssets = json.encode(
      assets.map((asset) => asset.toMap()).toList(),
    );

    return ReleasesCompanion(
      name: Value(name),
      tag: Value(tag),
      platform: Value(ReleaseProviderColumn.fromEntity(this)),
      publishedAt: Value(publishedAt),
      url: Value(url.toString()),
      organization: Value(organization),
      project: Value(project),
      authorId: Value(author.id),
      authorUsername: Value(author.username),
      authorProfileUrl: Value(author.profileUrl.toString()),
      createdAt: Value(DateTime.now()),
      description: Value(description),
      commit: Value(commit),
      assetsUrls: Value(jsonAssets),
    );
  }
}

extension ReleaseDataExtensions on Release {
  ReleaseEntity toEntity() {
    final jsonAssets = json.decode(assetsUrls) as List<dynamic>;
    final assets = jsonAssets
        .map((asset) => AssetEntity.fromMap(asset))
        .toList();

    return ReleaseEntity(
      name: name,
      tag: tag,
      platform: platform.toEntity(),
      publishedAt: publishedAt,
      url: Uri.parse(url),
      description: description,
      commit: commit,
      assets: assets,
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
