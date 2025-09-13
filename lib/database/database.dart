import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';
import 'package:magasin/database/tables/releases_table.dart';

part 'database.g.dart';

late MyEncryptedDatabase database;

void initDatabase() => database = MyEncryptedDatabase();

// Useless password for db encryption until I decide to implement properly this feature
const _encryptionPassword = 'dummy_password_on_purpose';

@DriftDatabase(tables: [Releases])
class MyEncryptedDatabase extends _$MyEncryptedDatabase {
  MyEncryptedDatabase() : super(_openDatabase());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {},
      onCreate: (Migrator m) async {
        await m.createAll();

        // seed database
      },
    );
  }
}

QueryExecutor _openDatabase() {
  return LazyDatabase(() async {
    final path = await getApplicationDocumentsDirectory();

    return NativeDatabase.createInBackground(
      File(p.join(path.path, 'magasin.database.enc')),
      isolateSetup: () async {
        open
          ..overrideFor(OperatingSystem.android, openCipherOnAndroid)
          ..overrideFor(
            OperatingSystem.linux,
            () => DynamicLibrary.open('libsqlcipher.so'),
          )
          ..overrideFor(
            OperatingSystem.windows,
            () => DynamicLibrary.open('sqlcipher.dll'),
          );
      },
      setup: (db) {
        // Check that we're actually running with SQLCipher by quering the
        // cipher_version pragma.
        final result = db.select('pragma cipher_version');
        if (result.isEmpty) {
          throw UnsupportedError(
            'This database needs to run with SQLCipher, but that library is '
            'not available!',
          );
        }

        // Then, apply the key to encrypt the database. Unfortunately, this
        // pragma doesn't seem to support prepared statements so we inline the
        // key.
        final escapedKey = _encryptionPassword.replaceAll("'", "''");
        db.execute("pragma key = '$escapedKey'");

        // Test that the key is correct by selecting from a table
        db.execute('select count(*) from sqlite_master');
      },
    );
  });
}
