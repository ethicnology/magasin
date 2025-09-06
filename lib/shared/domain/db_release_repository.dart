import 'package:magasin/database/database.dart';
import 'package:magasin/database/tables/releases_table.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/release_entity.dart';

class DbReleaseRepository {
  final MyEncryptedDatabase database;

  DbReleaseRepository(this.database);

  Future<List<ReleaseEntity>> fetch() async {
    final query = await database.select(database.releases).get();
    return query.map((row) => row.toEntity()).toList();
  }

  Future<void> store(ReleaseEntity release) async {
    await database
        .into(database.releases)
        .insertOnConflictUpdate(release.toCompanion());
  }
}
