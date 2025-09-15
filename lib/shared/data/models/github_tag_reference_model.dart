import 'package:dart_mappable/dart_mappable.dart';
import 'package:Magasin/utils.dart';

part 'github_tag_reference_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class GithubTagReferenceModel with GithubTagReferenceModelMappable {
  final String ref;
  final String nodeId;
  final UriEntity url;
  final GitObject object;

  GithubTagReferenceModel({
    required this.ref,
    required this.nodeId,
    required this.url,
    required this.object,
  });

  static final fromMap = GithubTagReferenceModelMapper.fromMap;
  static final fromJson = GithubTagReferenceModelMapper.fromJson;

  String getCommitHash() {
    if (object.type != 'commit') {
      throw Exception(
        'Tag does not point to a commit, found type: ${object.type}',
      );
    }
    return object.sha;
  }
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class GitObject with GitObjectMappable {
  final String sha;
  final String type;
  final UriEntity url;

  GitObject({required this.sha, required this.type, required this.url});
}
