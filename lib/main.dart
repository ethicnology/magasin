import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/pages/github_release_page.dart';
import 'presentation/cubit/cubit.dart';
import 'theme.dart';
import 'domain/usecases/get_latest_release_usecase.dart';
import 'domain/usecases/download_asset_usecase.dart';
import 'data/datasources/github_datasource.dart';
import 'domain/repositories/github_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magasin - GitHub Release Fetcher',
      theme: AppTheme.darkTheme,
      home: BlocProvider(
        create: (context) {
          final datasource = GitHubDatasource();
          final repository = GitHubRepository(datasource: datasource);
          final getLatestRelease = GetLatestReleaseUseCase(
            repository: repository,
          );
          final downloadAsset = DownloadAssetUseCase(repository: repository);

          return GitHubReleaseCubit(
            getLatestRelease: getLatestRelease,
            downloadAsset: downloadAsset,
          );
        },
        child: const GitHubReleasePageNew(),
      ),
    );
  }
}
