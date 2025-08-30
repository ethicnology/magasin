import 'github_user_entity.dart';

class GitHubAssetEntity {
  final int id;
  final String name;
  final String? label;
  final GitHubUserEntity uploader;
  final String contentType;
  final int size;
  final int downloadCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String browserDownloadUrl;

  const GitHubAssetEntity({
    required this.id,
    required this.name,
    this.label,
    required this.uploader,
    required this.contentType,
    required this.size,
    required this.downloadCount,
    required this.createdAt,
    required this.updatedAt,
    required this.browserDownloadUrl,
  });

  String get formattedSize {
    if (size < 1024) {
      return '${size}B';
    }
    if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(1)}KB';
    }
    if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }
}
