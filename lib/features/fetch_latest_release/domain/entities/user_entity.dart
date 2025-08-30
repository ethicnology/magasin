class UserEntity {
  final int id;
  final String username;
  final String displayName;
  final String avatarUrl;
  final String profileUrl;

  const UserEntity({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatarUrl,
    required this.profileUrl,
  });
}
