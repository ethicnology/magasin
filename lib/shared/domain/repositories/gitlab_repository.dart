import 'package:magasin/shared/domain/entities/release_entity.dart';
import 'package:magasin/shared/data/datasources/gitlab_datasource.dart';
import 'package:magasin/utils.dart';

class GitlabRepository {
  final _gitlabDatasource = GitLabDatasource();

  GitlabRepository();

  Future<ReleaseEntity> getLatestRelease(UriEntity url) async {
    try {
      final result = extractOwnerAndRepo(url);
      final model = await _gitlabDatasource.getLatestRelease(
        result.owner,
        result.repo,
      );
      final release = model.toEntity();
      return release;
    } catch (e) {
      throw Exception('Failed to get latest release: $e');
    }
  }
}
