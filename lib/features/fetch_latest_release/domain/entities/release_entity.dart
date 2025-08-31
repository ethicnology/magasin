import 'package:magasin/errors.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/asset_entity.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/user_entity.dart';

enum ReleaseProvider { github, gitlab }

class ReleaseEntity {
  final String organization;
  final String project;
  final ReleaseProvider platform;
  final String tag;
  final String commit;
  final Uri url;

  final String name;
  final String description;

  final DateTime publishedAt;

  final UserEntity author;

  final List<AssetEntity> assets;

  ReleaseEntity({
    required this.platform,
    required this.name,
    required this.tag,
    required this.description,
    required this.publishedAt,
    required this.url,
    required this.commit,
    required this.author,
    required this.assets,
    required this.organization,
    required this.project,
  }) {
    if (commit.length != 40) {
      throw AppError('Commit hash must be exactly 40 characters long');
    }
    if (!_isValidSha1(commit)) {
      throw AppError(
        'Commit hash must contain only hexadecimal characters (0-9, a-f)',
      );
    }
  }

  static bool _isValidSha1(String hash) {
    if (hash.length != 40) return false;
    return RegExp(r'^[a-f0-9]+$').hasMatch(hash.toLowerCase());
  }
}
