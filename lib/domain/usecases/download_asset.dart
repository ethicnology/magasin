import '../repositories/github_repository.dart';

class DownloadAsset {
  final GitHubRepository repository;

  DownloadAsset({required this.repository});

  Future<void> call(String downloadUrl, String fileName) async {
    if (downloadUrl.isEmpty) {
      throw Exception('Download URL cannot be empty');
    }

    if (fileName.isEmpty) {
      throw Exception('File name cannot be empty');
    }

    return await repository.downloadAsset(downloadUrl, fileName);
  }
}
