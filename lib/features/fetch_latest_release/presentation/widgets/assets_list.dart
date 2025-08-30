import 'package:flutter/material.dart';
import 'package:magasin/features/fetch_latest_release/presentation/utils/supported_platforms_enum.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/asset_entity.dart';
import '../utils/platform_utils.dart';

class AssetsList extends StatelessWidget {
  final List<AssetEntity> assets;
  final Function(AssetEntity) onDownload;
  final String? downloadingAsset;

  const AssetsList({
    super.key,
    required this.assets,
    required this.onDownload,
    this.downloadingAsset,
  });

  @override
  Widget build(BuildContext context) {
    final filteredAssets = assets.filterByPlatform();
    final isFiltered = filteredAssets.length != assets.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              isFiltered
                  ? 'Assets for ${SupportedPlatformExtensions.current.displayName}'
                  : 'All Assets',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 8),
            Chip(
              label: Text(
                isFiltered
                    ? '${filteredAssets.length}/${assets.length}'
                    : '${assets.length}',
              ),
            ),
          ],
        ),
        if (isFiltered) ...[
          const SizedBox(height: 4),
          Text(
            'Showing ${SupportedPlatformExtensions.current.displayName}-compatible files only',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ] else ...[
          const SizedBox(height: 4),
          Text(
            'No ${SupportedPlatformExtensions.current.displayName}-specific files found, showing all assets',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredAssets.length,
          itemBuilder: (context, index) {
            final asset = filteredAssets[index];
            final isDownloading = downloadingAsset == asset.name;

            return Card(
              child: ListTile(
                leading: Icon(asset.name.assetIcon),
                title: Text(asset.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Size: ${asset.formattedSize}'),
                    Text('Downloads: ${asset.downloadCount}'),
                    Text('Type: ${asset.contentType}'),
                  ],
                ),
                trailing: ElevatedButton.icon(
                  onPressed: isDownloading ? null : () => onDownload(asset),
                  icon: isDownloading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download),
                  label: Text(isDownloading ? 'Downloading...' : 'Download'),
                ),
                isThreeLine: true,
              ),
            );
          },
        ),
      ],
    );
  }
}

extension AssetListExtensions on List<AssetEntity> {
  List<AssetEntity> filterByPlatform([SupportedPlatform? platform]) {
    final targetPlatform = platform ?? SupportedPlatformExtensions.current;

    final filtered = where((asset) {
      return asset.name.targetPlatform == targetPlatform;
    }).toList();

    // If no platform-specific assets found, return all assets
    return filtered.isEmpty ? this : filtered;
  }

  List<AssetEntity> filterByPlatforms(List<SupportedPlatform> platforms) {
    final filtered = where((asset) {
      final assetPlatform = asset.name.targetPlatform;
      return assetPlatform != null && platforms.contains(assetPlatform);
    }).toList();

    // If no platform-specific assets found, return all assets
    return filtered.isEmpty ? this : filtered;
  }

  Map<SupportedPlatform, List<AssetEntity>> groupByPlatform() {
    final Map<SupportedPlatform, List<AssetEntity>> grouped = {};

    for (final asset in this) {
      final platform = asset.name.targetPlatform;
      if (platform != null) {
        grouped.putIfAbsent(platform, () => []).add(asset);
      }
    }

    return grouped;
  }
}
