import 'package:magasin/shared/domain/entities/asset_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadReleaseAssetUseCase {
  DownloadReleaseAssetUseCase();

  Future<void> call({required AssetEntity asset}) async {
    try {
      final uri = asset.url;
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch download URL');
      }
    } catch (e) {
      throw Exception('Failed to download asset: $e');
    }
  }
}
