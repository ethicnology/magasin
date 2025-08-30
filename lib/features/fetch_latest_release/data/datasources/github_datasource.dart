import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/github_release_model.dart';

class GitHubDatasource {
  final http.Client client;
  static const String baseUrl = 'https://api.github.com';

  GitHubDatasource({http.Client? client}) : client = client ?? http.Client();

  Future<GitHubReleaseModel> getLatestRelease(String owner, String repo) async {
    final url = '$baseUrl/repos/$owner/$repo/releases/latest';

    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return GitHubReleaseModelMapper.fromMap(json);
    } else if (response.statusCode == 404) {
      throw Exception('Repository not found or no releases available');
    } else {
      throw Exception('Failed to fetch release: ${response.statusCode}');
    }
  }

  String extractOwnerAndRepo(String githubUrl) {
    final uri = Uri.parse(githubUrl);

    if (uri.host != 'github.com') {
      throw Exception('Invalid GitHub URL');
    }

    final pathSegments = uri.pathSegments;
    if (pathSegments.length < 2) {
      throw Exception('Invalid GitHub repository URL');
    }

    return '${pathSegments[0]}/${pathSegments[1]}';
  }
}
