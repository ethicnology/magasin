import 'package:magasin/features/followed_releases/domain/entities/tracked_project_entity.dart';
import 'package:magasin/shared/domain/repositories/db_release_repository.dart';

class GetTrackedProjectsUseCase {
  final _dbReleaseRepository = DbReleaseRepository();

  GetTrackedProjectsUseCase();

  Future<List<TrackedProjectEntity>> call() async {
    final releases = await _dbReleaseRepository.fetch();

    final trackedProjects = <String, TrackedProjectEntity>{};

    for (var r in releases) {
      final key = '${r.platform.name}/${r.organization}/${r.project}';

      if (!trackedProjects.containsKey(key)) {
        trackedProjects[key] = TrackedProjectEntity(
          organization: r.organization,
          project: r.project,
          platform: r.platform,
          releases: [r],
          newRelease: null,
        );
      } else {
        final existingProject = trackedProjects[key]!;
        trackedProjects[key] = existingProject.copyWith(
          releases: [...existingProject.releases, r],
        );
      }
    }

    // sort releases ascending by publishedAt
    for (var project in trackedProjects.values) {
      project.releases.sort((a, b) => a.publishedAt.compareTo(b.publishedAt));
    }

    return trackedProjects.values.toList();
  }
}
