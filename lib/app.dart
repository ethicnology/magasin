import 'dart:io';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logging_colorful/logging_colorful.dart';
import 'package:magasin/database/database.dart';
import 'package:magasin/shared/domain/usecases/follow_futures_releases_usecase.dart';
import 'package:magasin/shared/domain/usecases/get_all_releases_usecase.dart';
import 'package:magasin/shared/domain/usecases/get_latest_release_usecase.dart';
import 'package:magasin/utils.dart';

class App {
  static final log = LoggerColorful(
    'Magasin',
    disabledColors: Platform.isIOS || kReleaseMode,
  );

  static final List<String> sessionLogs = [];

  static void initLogger() {
    Logger.root.level = Level.ALL;

    Logger.root.onRecord.listen((record) {
      final time = record.time.toIso8601String();
      final content = [time, record.level.name, record.message];

      final (:String error, :String trace) = record.stringifyErrorAndTrace();
      content.addAll([error, trace]);
      final sanitizedContent = content.map((e) => log.sanitize(e)).toList();
      final tsvLine = sanitizedContent.join('\t');

      sessionLogs.add(tsvLine);

      if (kDebugMode) debugPrint(content.join('\t'));
    });
  }

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    initLogger();

    MapperContainer.globals.use(UriMapper());

    MyEncryptedDatabase.init();

    await seedDatabase();
  }

  static Future<void> seedDatabase() async {
    try {
      final releases = await GetAllReleasesUsecase().call();
      if (releases.isNotEmpty) return;

      final githubUrl = 'https://github.com/ethicnology/magasin/releases';
      final project = UriEntity.parse(githubUrl);
      final release = await GetLatestReleaseUseCase().call(url: project);
      FollowFuturesReleasesUseCase().call(release: release);
    } catch (e) {
      log.severe(e);
    }
  }
}
