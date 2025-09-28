import 'package:Magasin/shared/domain/entities/release_entity.dart';
import 'package:Magasin/shared/data/datasources/gitlab_datasource.dart';
import 'package:Magasin/utils.dart';

class GitlabRepository {
  final _gitlabDatasource = GitLabDatasource();

  GitlabRepository();

  Future<ReleaseEntity> getLatestRelease(UriEntity url) async {
    final result = extractOwnerAndRepo(url);
    final model = await _gitlabDatasource.getLatestRelease(
      result.owner,
      result.repo,
    );
    final release = model.toEntity();
    return release;
  }
}
