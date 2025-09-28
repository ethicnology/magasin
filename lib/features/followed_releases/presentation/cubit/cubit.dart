import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Magasin/errors.dart';
import 'package:Magasin/features/followed_releases/domain/entities/tracked_project_entity.dart';
import 'package:Magasin/features/followed_releases/domain/usecases/get_tracked_projects_usecase.dart';
import 'package:Magasin/features/followed_releases/domain/usecases/unfollow_project_usecase.dart';
import 'package:Magasin/shared/domain/usecases/get_latest_release_usecase.dart';

import 'state.dart';

class FollowedReleasesCubit extends Cubit<FollowedReleasesState> {
  final _getTrackedProjectsUseCase = GetTrackedProjectsUseCase();
  final _unfollowProjectUseCase = UnfollowProjectUseCase();
  final _getLatestReleaseUseCase = GetLatestReleaseUseCase();

  FollowedReleasesCubit() : super(const FollowedReleasesState()) {
    loadTrackedProjects();
  }

  void clearError() => emit(state.copyWith(error: null));

  Future<void> loadTrackedProjects() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final projects = await _getTrackedProjectsUseCase();
      final projectsMap = Map.fromEntries(
        projects.map((project) => MapEntry(project.key, project)),
      );
      emit(state.copyWith(trackedProjects: projectsMap, isLoading: false));
    } on AppError catch (e) {
      emit(state.copyWith(error: e));
    } catch (e) {
      emit(state.copyWith(error: AppError(e.toString())));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> getLatestReleases() async {
    int countNewReleases = 0;
    for (var project in state.trackedProjects.values) {
      try {
        final latestRelease = await _getLatestReleaseUseCase(url: project.url);
        final releaseTags = project.releases.map((e) => e.tag).toList();

        if (!releaseTags.contains(latestRelease.tag)) {
          final updatedProject = project.copyWith(newRelease: latestRelease);
          final projectsCopied = Map.fromEntries(state.trackedProjects.entries);
          projectsCopied[project.key] = updatedProject;
          countNewReleases++;

          emit(
            state.copyWith(
              trackedProjects: projectsCopied,
              countNewReleases: countNewReleases,
            ),
          );
        }
      } on RateLimitError catch (e) {
        emit(state.copyWith(error: e));
        return;
      } catch (e) {
        emit(state.copyWith(error: AppError(e.toString())));
        continue;
      }
    }
  }

  Future<void> unfollowProject(TrackedProjectEntity project) async {
    try {
      await _unfollowProjectUseCase(
        organization: project.organization,
        project: project.project,
        platform: project.platform,
      );

      await loadTrackedProjects(); // reload
    } on AppError catch (e) {
      emit(state.copyWith(error: e));
    } catch (e) {
      emit(state.copyWith(error: AppError(e.toString())));
    }
  }
}
