import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_latest_release_usecase.dart';
import '../../domain/usecases/download_asset_usecase.dart';
import '../../domain/entities/github_asset_entity.dart';

import 'state.dart';

class GitHubReleaseCubit extends Cubit<GitHubReleaseState> {
  final GetLatestReleaseUseCase _getLatestRelease;
  final DownloadAssetUseCase _downloadAsset;

  GitHubReleaseCubit({
    required GetLatestReleaseUseCase getLatestRelease,
    required DownloadAssetUseCase downloadAsset,
  }) : _getLatestRelease = getLatestRelease,
       _downloadAsset = downloadAsset,
       super(const GitHubReleaseState.initial());

  Future<void> fetchRelease(Uri github) async {
    if (!github.toString().contains('github.com')) {
      emit(const GitHubReleaseState.error('Please enter a valid GitHub URL'));
      return;
    }

    emit(const GitHubReleaseState.loading());

    try {
      final release = await _getLatestRelease(github);
      emit(GitHubReleaseState.loaded(release));
    } catch (e) {
      emit(GitHubReleaseState.error(e.toString()));
    }
  }

  Future<void> downloadAsset(GitHubAssetEntity asset) async {
    final currentState = state;
    if (currentState.status != GitHubReleaseStatus.loaded ||
        currentState.release == null) {
      return;
    }

    emit(
      GitHubReleaseState.assetDownloading(currentState.release!, asset.name),
    );

    try {
      await _downloadAsset(asset.browserDownloadUrl, asset.name);
      emit(
        GitHubReleaseState.assetDownloadSuccess(
          currentState.release!,
          asset.name,
        ),
      );

      // Return to loaded state after a short delay
      await Future.delayed(const Duration(seconds: 2));
      emit(GitHubReleaseState.loaded(currentState.release!));
    } catch (e) {
      emit(
        GitHubReleaseState.assetDownloadError(
          currentState.release!,
          e.toString(),
        ),
      );

      // Return to loaded state after showing error
      await Future.delayed(const Duration(seconds: 3));
      emit(GitHubReleaseState.loaded(currentState.release!));
    }
  }

  void reset() {
    emit(const GitHubReleaseState.initial());
  }
}
