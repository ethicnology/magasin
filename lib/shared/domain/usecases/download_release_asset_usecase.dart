import 'package:magasin/shared/domain/entities/asset_entity.dart';
import 'package:magasin/shared/domain/repositories/release_repository.dart';

class DownloadReleaseAssetUseCase {
  final _repository = ReleaseRepository();

  DownloadReleaseAssetUseCase();

  Future<void> call({required AssetEntity asset}) async {
    return await _repository.downloadAsset(asset);
  }
}
