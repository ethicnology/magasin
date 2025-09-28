import 'package:Magasin/shared/domain/entities/release_entity.dart';
import 'package:Magasin/shared/data/datasources/github_datasource.dart';
import 'package:Magasin/utils.dart';

class GithubRepository {
  final _githubDatasource = GitHubDatasource();

  GithubRepository();

  Future<ReleaseEntity> getLatestRelease(UriEntity url) async {
    final result = extractOwnerAndRepo(url);
    final model = await _githubDatasource.getLatestRelease(
      result.owner,
      result.repo,
    );
    final commitHash = await _githubDatasource.getCommitHashForTag(
      result.owner,
      result.repo,
      model.tagName,
    );
    final release = model.toEntity(commitHash: commitHash);

    return release;
  }
}
