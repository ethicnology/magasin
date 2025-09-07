import 'package:magasin/shared/domain/entities/release_entity.dart';
import 'package:magasin/shared/domain/repositories/release_repository.dart';

class GetLatestReleaseUseCase {
  final _releaseRepository = ReleaseRepository();

  GetLatestReleaseUseCase();

  Future<ReleaseEntity> call({required Uri url}) async {
    return await _releaseRepository.getLatestRelease(url);
  }
}
