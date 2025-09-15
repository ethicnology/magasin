import 'package:Magasin/shared/domain/entities/release_entity.dart';
import 'package:Magasin/shared/domain/repositories/db_release_repository.dart';

class FollowFuturesReleasesUseCase {
  final _dbReleaseRepository = DbReleaseRepository();

  FollowFuturesReleasesUseCase();

  Future<void> call({required ReleaseEntity release}) async {
    try {
      await _dbReleaseRepository.store(release);
      return;
    } catch (e) {
      rethrow;
    }
  }
}
