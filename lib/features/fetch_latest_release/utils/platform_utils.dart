import 'package:flutter/material.dart';
import 'package:magasin/features/fetch_latest_release/utils/supported_platforms_enum.dart';

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
