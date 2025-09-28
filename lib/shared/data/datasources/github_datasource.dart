import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Magasin/errors.dart';
import 'package:Magasin/utils.dart';
import '../models/github_release_model.dart';
import '../models/github_tag_reference_model.dart';

class GitHubDatasource {
  final http.Client client;
  static const String baseUrl = 'https://api.github.com';

  GitHubDatasource({http.Client? client}) : client = client ?? http.Client();

  Future<GithubReleaseModel> getLatestRelease(String owner, String repo) async {
    final endpoint = '$baseUrl/repos/$owner/$repo/releases/latest';

    final response = await client.get(
      UriEntity.parse(endpoint),
      headers: {
        'Accept': 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return GithubReleaseModel.fromMap(json);
    } else if (response.statusCode == 404) {
      throw RepoNotFoundError('Repository not found or no releases available');
    } else if (response.statusCode == 403 || response.statusCode == 429) {
      throw RateLimitError(
        'GitHub API rate limit exceeded. Please try again later.',
      );
    } else {
      throw AppError('Failed to fetch release: ${response.statusCode}');
    }
  }

  Future<String> getCommitHashForTag(
    String owner,
    String repo,
    String tagName,
  ) async {
    final tagReference = await getTagReference(owner, repo, tagName);
    if (tagReference.object.type == 'tag') {
      return await _fetchCommitFromTagObject(
        tagReference.object.url.toString(),
      );
    } else if (tagReference.object.type == 'commit') {
      return tagReference.object.sha;
    } else {
      throw AppError('Invalid tag type: ${tagReference.object.type}');
    }
  }

  Future<String> _fetchCommitFromTagObject(String tagUrl) async {
    final endpoint = UriEntity.parse(tagUrl);
    final response = await client.get(endpoint);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['object']['type'] == 'commit') {
        return json['object']['sha'] as String;
      } else {
        throw AppError('Invalid tag type: ${json['object']['type']}');
      }
    } else if (response.statusCode == 403 || response.statusCode == 429) {
      throw RateLimitError(
        'GitHub API rate limit exceeded. Please try again later.',
      );
    } else {
      throw AppError('Failed to fetch commit: ${response.statusCode}');
    }
  }

  Future<GithubTagReferenceModel> getTagReference(
    String owner,
    String repo,
    String tagName,
  ) async {
    final endpoint = '$baseUrl/repos/$owner/$repo/git/ref/tags/$tagName';
    final response = await client.get(UriEntity.parse(endpoint));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return GithubTagReferenceModel.fromMap(json);
    } else if (response.statusCode == 404) {
      throw RepoNotFoundError('Tag not found: $tagName');
    } else if (response.statusCode == 403 || response.statusCode == 429) {
      throw RateLimitError(
        'GitHub API rate limit exceeded. Please try again later.',
      );
    } else {
      throw AppError('Failed to fetch tag: ${response.statusCode}');
    }
  }
}
