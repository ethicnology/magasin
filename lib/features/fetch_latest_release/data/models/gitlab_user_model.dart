import 'package:dart_mappable/dart_mappable.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/user_entity.dart';

part 'gitlab_user_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class GitLabUserModel with GitLabUserModelMappable {
  final int id;
  final String username;
  final String name;
  final String state;
  final String avatarUrl;
  final String webUrl;

  const GitLabUserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.state,
    required this.avatarUrl,
    required this.webUrl,
  });

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      displayName: name,
      avatarUrl: avatarUrl,
      profileUrl: webUrl,
    );
  }
}
