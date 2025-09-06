import 'package:magasin/features/fetch_latest_release/domain/entities/asset_entity.dart';
import 'package:magasin/features/fetch_latest_release/domain/repositories/release_repository.dart';

class DownloadReleaseAssetUseCase {
  final ReleaseRepository _repository;

  DownloadReleaseAssetUseCase(this._repository);

  Future<void> call({required AssetEntity asset}) async {
    return await _repository.downloadAsset(asset);
  }
}
