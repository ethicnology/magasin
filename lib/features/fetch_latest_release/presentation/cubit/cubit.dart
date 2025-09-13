import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magasin/errors.dart';
import 'package:magasin/shared/domain/usecases/get_latest_release_usecase.dart';
import 'package:magasin/utils.dart';

import 'state.dart';

class LatestReleaseCubit extends Cubit<LatestReleaseState> {
  final _getLatestReleaseUseCase = GetLatestReleaseUseCase();

  LatestReleaseCubit() : super(const LatestReleaseState());

  void reset() => emit(const LatestReleaseState());

  Future<void> fetchRelease(UriEntity url) async {
    if (!url.isGitHub && !url.isGitLab) {
      emit(
        state.copyWith(
          error: AppError('Please enter a valid Github or GitLab URL'),
        ),
      );
      return;
    }

    try {
      final release = await _getLatestReleaseUseCase(url: url);
      emit(state.copyWith(release: release));
    } catch (e) {
      emit(state.copyWith(error: AppError(e.toString())));
    }
  }
}
