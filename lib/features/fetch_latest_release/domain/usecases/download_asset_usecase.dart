import '../repositories/github_repository.dart';

class DownloadAssetUseCase {
  final GitHubRepository repository;

  DownloadAssetUseCase({required this.repository});

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
