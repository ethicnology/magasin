class GitHubUser {
  final String login;
  final int id;
  final String avatarUrl;
  final String htmlUrl;
  final String type;

  const GitHubUser({
    required this.login,
    required this.id,
    required this.avatarUrl,
    required this.htmlUrl,
    required this.type,
  });
}
