import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magasin/features/fetch_latest_release/domain/repositories/release_repository.dart';
import 'package:magasin/utils.dart';
import 'features/fetch_latest_release/presentation/pages/fetch_latest_release_page.dart';
import 'features/fetch_latest_release/presentation/cubit/cubit.dart';
import 'theme.dart';
import 'features/fetch_latest_release/domain/usecases/get_release_usecase.dart';
import 'features/fetch_latest_release/domain/usecases/download_release_asset_usecase.dart';
import 'features/fetch_latest_release/data/datasources/github_datasource.dart';
import 'features/fetch_latest_release/data/datasources/gitlab_datasource.dart';

void main() {
  MapperContainer.globals.use(UriMapper());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magasin',
      theme: AppTheme.darkTheme,
      home: BlocProvider(
        create: (context) {
          final githubDatasource = GitHubDatasource();
          final gitlabDatasource = GitLabDatasource();

          final releaseRepository = ReleaseRepository(
            githubDatasource: githubDatasource,
            gitlabDatasource: gitlabDatasource,
          );

          final getRelease = GetReleaseUseCase(releaseRepository);
          final downloadAsset = DownloadReleaseAssetUseCase(releaseRepository);

          return GitHubReleaseCubit(
            getRelease: getRelease,
            downloadAsset: downloadAsset,
          );
        },
        child: const FetchLatestReleasePage(),
      ),
    );
  }
}
