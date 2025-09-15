import 'package:drift/drift.dart';
import 'package:Magasin/database/database.dart';
import 'package:Magasin/database/tables/releases_table.dart';
import 'package:Magasin/shared/domain/entities/release_entity.dart';

class DbReleaseRepository {
  DbReleaseRepository();

  Future<List<ReleaseEntity>> fetch() async {
    final query = await database.select(database.releases).get();
    return query.map((row) => row.toEntity()).toList();
  }

  Future<void> store(ReleaseEntity release) async {
    await database
        .into(database.releases)
        .insertOnConflictUpdate(release.toCompanion());
  }

  Future<void> trash({
    required String organization,
    required String project,
    required ReleaseProvider platform,
  }) async {
    await (database.delete(database.releases)..where(
          (t) =>
              t.organization.equals(organization) &
              t.project.equals(project) &
              t.platform.equals(platform.name),
        ))
        .go();
  }
}
