import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magasin/errors.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/asset_entity.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/release_entity.dart';
import 'package:magasin/features/fetch_latest_release/domain/usecases/follow_futures_releases_usecase.dart';
import 'package:magasin/shared/domain/usecases/get_latest_release_usecase.dart';
import 'package:magasin/features/fetch_latest_release/domain/usecases/download_release_asset_usecase.dart';
import 'package:magasin/utils.dart';

import 'state.dart';

class LatestReleaseCubit extends Cubit<LatestReleaseState> {
  final GetLatestReleaseUseCase getLatestReleaseUseCase;
  final DownloadReleaseAssetUseCase downloadAssetUseCase;
  final FollowFuturesReleasesUseCase followFuturesReleasesUseCase;

  LatestReleaseCubit({
    required this.getLatestReleaseUseCase,
    required this.downloadAssetUseCase,
    required this.followFuturesReleasesUseCase,
  }) : super(const LatestReleaseState());

  void reset() => emit(const LatestReleaseState());

  Future<void> fetchRelease(Uri url) async {
    if (url.isGitHub && url.isGitLab) {
      emit(
        state.copyWith(
          error: AppError('Please enter a valid Github or GitLab URL'),
        ),
      );
      return;
    }

    try {
      final release = await getLatestReleaseUseCase(url);
      emit(state.copyWith(release: release));
    } catch (e) {
      emit(state.copyWith(error: AppError(e.toString())));
    }
  }

  Future<void> downloadAsset(AssetEntity asset) async {
    try {
      await downloadAssetUseCase(asset);
    } catch (e) {
      emit(state.copyWith(error: AppError(e.toString())));
    }
  }

  Future<void> followFuturesReleases(ReleaseEntity release) async {
    if (state.release == null) return;

    try {
      await followFuturesReleasesUseCase(release);
    } catch (e) {
      emit(state.copyWith(error: AppError(e.toString())));
    }
  }
}
