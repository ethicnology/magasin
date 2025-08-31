import 'package:magasin/database/database.dart';
import 'package:magasin/database/tables/releases_table.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/release_entity.dart';

class FollowFuturesReleasesUseCase {
  FollowFuturesReleasesUseCase();

  Future<void> call(ReleaseEntity release) async {
    try {
      await database
          .into(database.releases)
          .insertOnConflictUpdate(release.toCompanion());
      return;
    } catch (e) {
      rethrow;
    }
  }
}
