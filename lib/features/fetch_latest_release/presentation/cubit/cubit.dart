import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magasin/features/fetch_latest_release/domain/usecases/get_release_usecase.dart';
import 'package:magasin/features/fetch_latest_release/domain/usecases/download_release_asset_usecase.dart';

import 'state.dart';

class GitHubReleaseCubit extends Cubit<GitHubReleaseState> {
  final GetReleaseUseCase _getRelease;
  final DownloadReleaseAssetUseCase _downloadAsset;

  GitHubReleaseCubit({
    required GetReleaseUseCase getRelease,
    required DownloadReleaseAssetUseCase downloadAsset,
  }) : _getRelease = getRelease,
       _downloadAsset = downloadAsset,
       super(const GitHubReleaseState.initial());

  Future<void> fetchRelease(Uri url) async {
    if (url.host != 'github.com' && url.host != 'gitlab.com') {
      emit(
        const GitHubReleaseState.error(
          'Please enter a valid GitHub or GitLab URL',
        ),
      );
      return;
    }

    emit(const GitHubReleaseState.loading());

    try {
      final release = await _getRelease(url);
      emit(GitHubReleaseState.loaded(release));
    } catch (e) {
      emit(GitHubReleaseState.error(e.toString()));
    }
  }

  Future<void> downloadAsset(dynamic asset) async {
    final currentState = state;
    if (currentState.status != GitHubReleaseStatus.loaded ||
        currentState.release == null) {
      return;
    }

    final platform = currentState.release!.platform;

    final assetName = asset.name;
    final downloadUrl = asset.browserDownloadUrl;

    emit(GitHubReleaseState.assetDownloading(currentState.release!, assetName));

    try {
      await _downloadAsset(downloadUrl, assetName, platform);
      emit(
        GitHubReleaseState.assetDownloadSuccess(
          currentState.release!,
          assetName,
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
