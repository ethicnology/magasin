import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/widgets.dart';
import 'package:magasin/database/database.dart';
import 'package:magasin/shared/domain/usecases/follow_futures_releases_usecase.dart';
import 'package:magasin/shared/domain/usecases/get_all_releases_usecase.dart';
import 'package:magasin/shared/domain/usecases/get_latest_release_usecase.dart';
import 'package:magasin/utils.dart';

class App {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

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
    } catch (_) {}
  }
}
