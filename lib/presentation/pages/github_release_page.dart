import 'package:flutter/material.dart';
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
      body: Padding(
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
                  child: Text(
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
              Text(
                'Assets (${_release!.assets.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _release!.assets.length,
                  itemBuilder: (context, index) {
                    final asset = _release!.assets[index];
                    return Card(
                      child: ListTile(
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
              ),
            ],
          ],
        ),
      ),
    );
  }
}
