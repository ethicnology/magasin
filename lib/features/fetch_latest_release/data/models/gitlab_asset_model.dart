import 'package:dart_mappable/dart_mappable.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/asset_entity.dart';

part 'gitlab_asset_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class GitLabAssetModel with GitLabAssetModelMappable {
  final int? id;
  final String name;
  final String url;
  final String directAssetUrl;
  final String linkType;
  final String? format;

  const GitLabAssetModel({
    this.id,
    required this.name,
    required this.url,
    required this.directAssetUrl,
    required this.linkType,
    this.format,
  });

  AssetEntity toEntity() {
    return AssetEntity(
      id: id,
      name: name,
      downloadUrl: directAssetUrl,
      formattedSize: 'Unknown', // GitLab API doesn't provide size
      downloadCount: 0, // GitLab API doesn't provide download count
      contentType: _getContentTypeFromFormat(
        format ?? _extractFormatFromName(name),
      ),
    );
  }

  String _extractFormatFromName(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return extension;
  }

  String _getContentTypeFromFormat(String format) {
    switch (format.toLowerCase()) {
      case 'zip':
        return 'application/zip';
      case 'tar.gz':
        return 'application/gzip';
      case 'tar.bz2':
        return 'application/x-bzip2';
      case 'tar':
        return 'application/x-tar';
      case 'apk':
        return 'application/vnd.android.package-archive';
      default:
        return 'application/octet-stream';
    }
  }
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class GitLabSourceAssetModel with GitLabSourceAssetModelMappable {
  final String format;
  final String url;

  const GitLabSourceAssetModel({required this.format, required this.url});

  AssetEntity toEntity(String releaseName) {
    return AssetEntity(
      name: '$releaseName.$format',
      downloadUrl: url,
      formattedSize: 'Unknown',
      downloadCount: 0,
      contentType: _getContentTypeFromFormat(format),
    );
  }

  String _getContentTypeFromFormat(String format) {
    switch (format.toLowerCase()) {
      case 'zip':
        return 'application/zip';
      case 'tar.gz':
        return 'application/gzip';
      case 'tar.bz2':
        return 'application/x-bzip2';
      case 'tar':
        return 'application/x-tar';
      default:
        return 'application/octet-stream';
    }
  }
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class GitLabAssetsModel with GitLabAssetsModelMappable {
  final int count;
  final List<GitLabSourceAssetModel> sources;
  final List<GitLabAssetModel> links;

  const GitLabAssetsModel({
    required this.count,
    required this.sources,
    required this.links,
  });
}
