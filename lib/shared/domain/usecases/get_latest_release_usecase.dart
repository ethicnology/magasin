import 'package:magasin/features/fetch_latest_release/domain/entities/release_entity.dart';
import 'package:magasin/features/fetch_latest_release/domain/repositories/release_repository.dart';

class GetLatestReleaseUseCase {
  final ReleaseRepository _repository;

  GetLatestReleaseUseCase(this._repository);

  Future<ReleaseEntity> call(Uri url) async {
    return await _repository.getLatestRelease(url);
  }
}
