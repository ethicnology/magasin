import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:magasin/database/tables/releases_table.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/asset_entity.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/release_entity.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/user_entity.dart';
import 'package:magasin/database/database.dart';

extension ReleaseEntityExtensions on ReleaseEntity {
  ReleasesCompanion toCompanion() {
    final encodedAssets = json.encode(
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
      assets: Value(encodedAssets),
    );
  }
}

extension ReleaseDataExtensions on Release {
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
