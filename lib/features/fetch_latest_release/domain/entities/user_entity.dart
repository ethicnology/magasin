class UserEntity {
  final int id;
  final String username;
  final Uri avatarUrl;
  final Uri profileUrl;

  const UserEntity({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.profileUrl,
  });
}
