import '../entities/github_release_entity.dart';
import '../repositories/github_repository.dart';

class GetLatestReleaseUseCase {
  final GitHubRepository repository;

  GetLatestReleaseUseCase({required this.repository});

  Future<GitHubReleaseEntity> call(Uri github) async {
    return await repository.getLatestRelease(github);
  }
}
