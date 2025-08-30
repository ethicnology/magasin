import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/github_release.dart';
import '../../domain/entities/github_asset.dart';
import '../../domain/usecases/get_latest_release.dart';
import '../../domain/usecases/download_asset.dart';
import '../../data/datasources/github_datasource.dart';
import '../../domain/repositories/github_repository.dart';

class GitHubReleasePage extends StatefulWidget {
  const GitHubReleasePage({super.key});

  @override
  State<GitHubReleasePage> createState() => _GitHubReleasePageState();
}

class _GitHubReleasePageState extends State<GitHubReleasePage> {
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late final GetLatestRelease _getLatestRelease;
  late final DownloadAsset _downloadAsset;

  GitHubRelease? _release;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final datasource = GitHubDatasource();
    final repository = GitHubRepository(datasource: datasource);
    _getLatestRelease = GetLatestRelease(repository: repository);
    _downloadAsset = DownloadAsset(repository: repository);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _fetchRelease() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _release = null;
    });

    try {
      final release = await _getLatestRelease(_urlController.text.trim());
      setState(() {
        _release = release;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<GitHubAsset> _getFilteredAssets(List<GitHubAsset> assets) {
    final platformExtensions = _getPlatformExtensions();

    final filtered = assets.where((asset) {
      final fileName = asset.name.toLowerCase();
      return platformExtensions.any((ext) => fileName.endsWith(ext));
    }).toList();

    // If no platform-specific assets found, return all assets
    return filtered.isEmpty ? assets : filtered;
  }

  List<String> _getPlatformExtensions() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return ['.apk', '.aab'];
      case TargetPlatform.iOS:
        return ['.ipa'];
      case TargetPlatform.windows:
        return ['.exe', '.msi', '.msix'];
      case TargetPlatform.macOS:
        return ['.dmg', '.pkg', '.app.zip'];
      case TargetPlatform.linux:
        return ['.appimage', '.deb', '.rpm', '.tar.gz', '.snap', '.flatpak'];
      case TargetPlatform.fuchsia:
        return ['.far'];
    }
  }

  String _getPlatformName() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'Android';
      case TargetPlatform.iOS:
        return 'iOS';
      case TargetPlatform.windows:
        return 'Windows';
      case TargetPlatform.macOS:
        return 'macOS';
      case TargetPlatform.linux:
        return 'Linux';
      case TargetPlatform.fuchsia:
        return 'Fuchsia';
    }
  }

  IconData _getAssetIcon(String fileName) {
    final name = fileName.toLowerCase();

    if (name.endsWith('.apk') || name.endsWith('.aab')) {
      return Icons.android;
    } else if (name.endsWith('.ipa')) {
      return Icons.phone_iphone;
    } else if (name.endsWith('.exe') ||
        name.endsWith('.msi') ||
        name.endsWith('.msix')) {
      return Icons.desktop_windows;
    } else if (name.endsWith('.dmg') ||
        name.endsWith('.pkg') ||
        name.endsWith('.app.zip')) {
      return Icons.laptop_mac;
    } else if (name.endsWith('.appimage') ||
        name.endsWith('.deb') ||
        name.endsWith('.rpm') ||
        name.endsWith('.snap') ||
        name.endsWith('.flatpak')) {
      return Icons.computer;
    } else if (name.endsWith('.tar.gz') || name.endsWith('.zip')) {
      return Icons.archive;
    } else if (name.contains('source') || name.endsWith('.tar.gz')) {
      return Icons.code;
    } else {
      return Icons.insert_drive_file;
    }
  }

  Future<void> _downloadAssetFile(GitHubAsset asset) async {
    try {
      await _downloadAsset(asset.browserDownloadUrl, asset.name);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Downloading ${asset.name}...'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Release Fetcher'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _urlController,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    enableSuggestions: true,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'GitHub Repository URL',
                      hintText: 'https://github.com/owner/repository',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.link),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a GitHub URL';
                      }
                      if (!value.contains('github.com')) {
                        return 'Please enter a valid GitHub URL';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _fetchRelease(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _fetchRelease,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Fetch Latest Release'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_error != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SelectableText(
                    _error!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              ),
            if (_release != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _release!.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tag: ${_release!.tagName}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Published: ${_release!.publishedAt.toLocal().toString().split('.')[0]}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (_release!.body.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Description:',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(_release!.body),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (context) {
                  final filteredAssets = _getFilteredAssets(_release!.assets);
                  final isFiltered =
                      filteredAssets.length != _release!.assets.length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            isFiltered
                                ? 'Assets for ${_getPlatformName()}'
                                : 'All Assets',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(
                              isFiltered
                                  ? '${filteredAssets.length}/${_release!.assets.length}'
                                  : '${_release!.assets.length}',
                            ),
                            backgroundColor: isFiltered
                                ? Colors.blue.shade100
                                : Colors.grey.shade100,
                          ),
                        ],
                      ),
                      if (isFiltered) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Showing ${_getPlatformName()}-compatible files only',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ] else ...[
                        const SizedBox(height: 4),
                        Text(
                          'No ${_getPlatformName()}-specific files found, showing all assets',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredAssets.length,
                        itemBuilder: (context, index) {
                          final asset = filteredAssets[index];
                          return Card(
                            child: ListTile(
                              leading: Icon(
                                _getAssetIcon(asset.name),
                                color: Colors.blue.shade600,
                              ),
                              title: Text(asset.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Size: ${asset.formattedSize}'),
                                  Text('Downloads: ${asset.downloadCount}'),
                                  Text('Type: ${asset.contentType}'),
                                ],
                              ),
                              trailing: ElevatedButton.icon(
                                onPressed: () => _downloadAssetFile(asset),
                                icon: const Icon(Icons.download),
                                label: const Text('Download'),
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
