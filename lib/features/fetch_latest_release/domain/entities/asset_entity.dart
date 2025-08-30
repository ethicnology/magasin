class AssetEntity {
  final int? id;
  final String name;
  final String downloadUrl;
  final String formattedSize;
  final int downloadCount;
  final String contentType;

  const AssetEntity({
    this.id,
    required this.name,
    required this.downloadUrl,
    required this.formattedSize,
    required this.downloadCount,
    required this.contentType,
  });
}
