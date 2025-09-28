import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Magasin/errors.dart';
import 'package:Magasin/shared/data/models/gitlab_release_model.dart';

class GitLabDatasource {
  final http.Client client;
  static const String baseUrl = 'https://gitlab.com/api/v4';

  GitLabDatasource({http.Client? client}) : client = client ?? http.Client();

  Future<GitlabReleaseModel> getLatestRelease(String owner, String repo) async {
    final encodedPath = Uri.encodeComponent('$owner/$repo');
    final endpoint = '$baseUrl/projects/$encodedPath/releases';

    final response = await client.get(
      Uri.parse(endpoint),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as List<dynamic>;

      if (jsonList.isEmpty) {
        throw RepoNotFoundError('No releases found for this project');
      }

      // Get the first (latest) release
      final json = jsonList.first as Map<String, dynamic>;
      return GitlabReleaseModel.fromMap(json);
    } else if (response.statusCode == 404) {
      throw RepoNotFoundError('Project not found or no releases available');
    } else if (response.statusCode == 429) {
      throw RateLimitError(
        'GitLab API rate limit exceeded. Please try again later.',
      );
    } else {
      throw AppError('Failed to fetch release: ${response.statusCode}');
    }
  }

  String extractProjectPath(String gitlabUrl) {
    final uri = Uri.parse(gitlabUrl);

    if (uri.host != 'gitlab.com') {
      throw AppError('Invalid GitLab URL');
    }

    final pathSegments = uri.pathSegments;
    if (pathSegments.length < 2) {
      throw AppError('Invalid GitLab repository URL');
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
      throw AppError('Invalid GitLab repository URL');
    }

    return cleanSegments.join('/');
  }
}
