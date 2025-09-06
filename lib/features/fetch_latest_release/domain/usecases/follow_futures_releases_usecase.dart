import 'package:magasin/features/fetch_latest_release/domain/entities/release_entity.dart';
import 'package:magasin/shared/domain/repositories/db_release_repository.dart';

class FollowFuturesReleasesUseCase {
  final DbReleaseRepository dbReleaseRepository;

  FollowFuturesReleasesUseCase(this.dbReleaseRepository);

  Future<void> call(ReleaseEntity release) async {
    try {
      await dbReleaseRepository.store(release);
      return;
    } catch (e) {
      rethrow;
    }
  }
}
