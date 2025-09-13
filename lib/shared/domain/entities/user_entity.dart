import 'package:magasin/utils.dart';

class UserEntity {
  final int id;
  final String username;
  final UriEntity avatarUrl;
  final UriEntity profileUrl;

  const UserEntity({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.profileUrl,
  });
}
