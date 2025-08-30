import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/fetch_latest_release/presentation/pages/fetch_latest_release_page.dart';
import 'features/fetch_latest_release/presentation/cubit/cubit.dart';
import 'theme.dart';
import 'features/fetch_latest_release/domain/usecases/get_release_usecase.dart';
import 'features/fetch_latest_release/domain/usecases/download_release_asset_usecase.dart';
import 'features/fetch_latest_release/data/datasources/github_datasource.dart';
import 'features/fetch_latest_release/data/datasources/gitlab_datasource.dart';
import 'features/fetch_latest_release/domain/repositories/github_repository.dart';
import 'features/fetch_latest_release/domain/repositories/gitlab_repository.dart';

void main() {
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
          final githubRepository = GitHubRepository(
            datasource: githubDatasource,
          );
          final gitlabRepository = GitLabRepository(
            datasource: gitlabDatasource,
          );

          final getRelease = GetReleaseUseCase(
            githubRepository: githubRepository,
            gitlabRepository: gitlabRepository,
          );
          final downloadAsset = DownloadReleaseAssetUseCase(
            githubRepository: githubRepository,
            gitlabRepository: gitlabRepository,
          );

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
