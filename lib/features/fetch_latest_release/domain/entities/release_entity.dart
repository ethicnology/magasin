import 'package:magasin/features/fetch_latest_release/domain/entities/asset_entity.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/user_entity.dart';

enum PlatformType { github, gitlab }

class ReleaseEntity {
  final PlatformType platform;
  final int id;
  final String name;
  final String tagName;
  final String body;
  final DateTime publishedAt;
  final String htmlUrl;
  final UserEntity author;
  final List<AssetEntity> assets;

  const ReleaseEntity({
    required this.platform,
    required this.id,
    required this.name,
    required this.tagName,
    required this.body,
    required this.publishedAt,
    required this.htmlUrl,
    required this.author,
    required this.assets,
  });

  String get authorName => author.displayName;
  String get authorAvatarUrl => author.avatarUrl;
}
