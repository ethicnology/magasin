import 'package:magasin/shared/domain/entities/release_entity.dart';
import 'package:magasin/shared/domain/repositories/db_release_repository.dart';

class UnfollowProjectUseCase {
  final _dbReleaseRepository = DbReleaseRepository();

  UnfollowProjectUseCase();

  Future<void> call({
    required String organization,
    required String project,
    required ReleaseProvider platform,
  }) async {
    return await _dbReleaseRepository.trash(
      organization: organization,
      project: project,
      platform: platform,
    );
  }
}
