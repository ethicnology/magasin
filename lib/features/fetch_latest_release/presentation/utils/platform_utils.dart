import 'package:flutter/material.dart';
import 'package:magasin/features/fetch_latest_release/presentation/utils/supported_platforms_enum.dart';
import '../../domain/entities/github_asset_entity.dart';

extension GitHubAssetListExtensions on List<GitHubAssetEntity> {
  List<GitHubAssetEntity> filterByPlatform([SupportedPlatform? platform]) {
    final targetPlatform = platform ?? SupportedPlatformExtensions.current;

    final filtered = where(
      (asset) => asset.name.targetPlatform == targetPlatform,
    ).toList();

    // If no platform-specific assets found, return all assets
    return filtered.isEmpty ? this : filtered;
  }

  List<GitHubAssetEntity> filterByPlatforms(List<SupportedPlatform> platforms) {
    final filtered = where((asset) {
      final assetPlatform = asset.name.targetPlatform;
      return assetPlatform != null && platforms.contains(assetPlatform);
    }).toList();

    // If no platform-specific assets found, return all assets
    return filtered.isEmpty ? this : filtered;
  }

  Map<SupportedPlatform, List<GitHubAssetEntity>> groupByPlatform() {
    final Map<SupportedPlatform, List<GitHubAssetEntity>> grouped = {};

    for (final asset in this) {
      final platform = asset.name.targetPlatform;
      if (platform != null) {
        grouped.putIfAbsent(platform, () => []).add(asset);
      }
    }

    return grouped;
  }
}

extension StringAssetExtensions on String {
  IconData get assetIcon {
    final name = toLowerCase();

    // Check which platform this asset belongs to based on extensions
    for (final platform in SupportedPlatform.values) {
      if (platform.extensions.any((ext) => name.endsWith(ext))) {
        return platform.icon;
      }
    }

    // Fallback icons for common file types
    if (name.endsWith('.tar.gz') || name.endsWith('.zip')) {
      return Icons.archive;
    } else if (name.contains('source')) {
      return Icons.code;
    } else {
      return Icons.insert_drive_file;
    }
  }

  SupportedPlatform? get targetPlatform {
    final name = toLowerCase();

    for (final platform in SupportedPlatform.values) {
      if (platform.extensions.any((ext) => name.endsWith(ext))) {
        return platform;
      }
    }

    return null;
  }
}
