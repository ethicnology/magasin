import 'package:flutter/material.dart';
import 'package:magasin/presentation/utils/supported_platforms_enum.dart';
import '../../domain/entities/github_asset_entity.dart';
import '../utils/platform_utils.dart';

class AssetsList extends StatelessWidget {
  final List<GitHubAssetEntity> assets;
  final Function(GitHubAssetEntity) onDownload;
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
              backgroundColor: isFiltered
                  ? Colors.blue.shade100
                  : Colors.grey.shade100,
            ),
          ],
        ),
        if (isFiltered) ...[
          const SizedBox(height: 4),
          Text(
            'Showing ${SupportedPlatformExtensions.current.displayName}-compatible files only',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
          ),
        ] else ...[
          const SizedBox(height: 4),
          Text(
            'No ${SupportedPlatformExtensions.current.displayName}-specific files found, showing all assets',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
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
                leading: Icon(
                  asset.name.assetIcon,
                  color: Colors.blue.shade600,
                ),
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
