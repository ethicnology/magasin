import 'package:Magasin/shared/domain/entities/release_entity.dart';
import 'package:Magasin/shared/domain/repositories/github_repository.dart';
import 'package:Magasin/shared/domain/repositories/gitlab_repository.dart';
import 'package:Magasin/utils.dart';

class GetLatestReleaseUseCase {
  final _githubRepository = GithubRepository();
  final _gitlabRepository = GitlabRepository();

  GetLatestReleaseUseCase();

  Future<ReleaseEntity> call({required UriEntity url}) async {
    if (url.isGitHub) {
      return await _githubRepository.getLatestRelease(url);
    } else if (url.isGitLab) {
      return await _gitlabRepository.getLatestRelease(url);
    } else {
      throw Exception('Invalid URL');
    }
  }
}
