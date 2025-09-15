import 'package:dart_mappable/dart_mappable.dart';
import 'package:Magasin/errors.dart';
import 'package:Magasin/features/followed_releases/domain/entities/tracked_project_entity.dart';

part 'state.mapper.dart';

@MappableClass()
class FollowedReleasesState with FollowedReleasesStateMappable {
  final Map<String, TrackedProjectEntity> trackedProjects;
  final int countNewReleases;
  final bool isLoading;
  final AppError? error;

  const FollowedReleasesState({
    this.trackedProjects = const {},
    this.countNewReleases = 0,
    this.isLoading = false,
    this.error,
  });
}
