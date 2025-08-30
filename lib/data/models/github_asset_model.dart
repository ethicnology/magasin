import 'package:dart_mappable/dart_mappable.dart';
import 'github_user_model.dart';
import '../../domain/entities/github_asset_entity.dart';

part 'github_asset_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class GitHubAssetModel with GitHubAssetModelMappable {
  final String url;
  final int id;
  final String nodeId;
  final String name;
  final String? label;
  final GitHubUserModel uploader;
  final String contentType;
  final String state;
  final int size;
  final String digest;
  final int downloadCount;
  final String createdAt;
  final String updatedAt;
  final String browserDownloadUrl;

  const GitHubAssetModel({
    required this.url,
    required this.id,
    required this.nodeId,
    required this.name,
    this.label,
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

  GitHubAssetEntity toEntity() {
    return GitHubAssetEntity(
      id: id,
      name: name,
      label: label,
      uploader: uploader.toEntity(),
      contentType: contentType,
      size: size,
      downloadCount: downloadCount,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      browserDownloadUrl: browserDownloadUrl,
    );
  }
}
