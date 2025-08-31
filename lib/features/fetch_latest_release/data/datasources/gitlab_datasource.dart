import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:magasin/features/fetch_latest_release/data/models/gitlab_release_model.dart';

class GitLabDatasource {
  final http.Client client;
  static const String baseUrl = 'https://gitlab.com/api/v4';

  GitLabDatasource({http.Client? client}) : client = client ?? http.Client();

  Future<GitlabReleaseModel> getLatestRelease(String owner, String repo) async {
    final encodedPath = Uri.encodeComponent('$owner/$repo');
    final url = '$baseUrl/projects/$encodedPath/releases';

    final response = await client.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as List<dynamic>;

      if (jsonList.isEmpty) {
        throw Exception('No releases found for this project');
      }

      // Get the first (latest) release
      final json = jsonList.first as Map<String, dynamic>;
      return GitlabReleaseModelMapper.fromMap(json);
    } else if (response.statusCode == 404) {
      throw Exception('Project not found or no releases available');
    } else {
      throw Exception('Failed to fetch release: ${response.statusCode}');
    }
  }

  String extractProjectPath(String gitlabUrl) {
    final uri = Uri.parse(gitlabUrl);

    if (uri.host != 'gitlab.com') {
      throw Exception('Invalid GitLab URL');
    }

    final pathSegments = uri.pathSegments;
    if (pathSegments.length < 2) {
      throw Exception('Invalid GitLab repository URL');
    }

    // Remove trailing segments like /-/releases, /-/issues, etc.
    final cleanSegments = <String>[];
    for (int i = 0; i < pathSegments.length; i++) {
      if (pathSegments[i].startsWith('-')) {
        break;
      }
      cleanSegments.add(pathSegments[i]);
    }

    if (cleanSegments.length < 2) {
      throw Exception('Invalid GitLab repository URL');
    }

    return cleanSegments.join('/');
  }
}
