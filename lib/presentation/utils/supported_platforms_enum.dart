import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum SupportedPlatform { android, ios, windows, macos, linux }

extension SupportedPlatformExtensions on SupportedPlatform {
  List<String> get extensions {
    switch (this) {
      case SupportedPlatform.android:
        return ['.apk', '.aab'];
      case SupportedPlatform.ios:
        return ['.ipa'];
      case SupportedPlatform.windows:
        return ['.exe', '.msi', '.msix'];
      case SupportedPlatform.macos:
        return ['.dmg', '.pkg', '.app.zip'];
      case SupportedPlatform.linux:
        return ['.appimage', '.deb', '.rpm', '.tar.gz', '.snap', '.flatpak'];
    }
  }

  String get displayName {
    switch (this) {
      case SupportedPlatform.android:
        return 'Android';
      case SupportedPlatform.ios:
        return 'iOS';
      case SupportedPlatform.windows:
        return 'Windows';
      case SupportedPlatform.macos:
        return 'macOS';
      case SupportedPlatform.linux:
        return 'Linux';
    }
  }

  IconData get icon {
    switch (this) {
      case SupportedPlatform.android:
        return Icons.android;
      case SupportedPlatform.ios:
        return Icons.phone_iphone;
      case SupportedPlatform.windows:
        return Icons.desktop_windows;
      case SupportedPlatform.macos:
        return Icons.laptop_mac;
      case SupportedPlatform.linux:
        return Icons.computer;
    }
  }

  static SupportedPlatform get current {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return SupportedPlatform.android;
      case TargetPlatform.iOS:
        return SupportedPlatform.ios;
      case TargetPlatform.windows:
        return SupportedPlatform.windows;
      case TargetPlatform.macOS:
        return SupportedPlatform.macos;
      case TargetPlatform.linux:
        return SupportedPlatform.linux;
      default:
        throw UnsupportedError('Unsupported platform: $defaultTargetPlatform');
    }
  }
}
