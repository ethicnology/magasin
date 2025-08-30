import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cubit.dart';
import '../cubit/state.dart';
import '../widgets/release_info_card.dart';
import '../widgets/assets_list.dart';

class FetchLatestReleasePage extends StatelessWidget {
  const FetchLatestReleasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GitHubReleaseCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('GitHub & GitLab Release Fetcher')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _UrlInputForm(),
            const SizedBox(height: 24),
            BlocConsumer<GitHubReleaseCubit, GitHubReleaseState>(
              listener: (context, state) {
                if (state.status == GitHubReleaseStatus.assetDownloadSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Downloaded ${state.downloadingAssetName} successfully!',
                      ),
                    ),
                  );
                } else if (state.status ==
                    GitHubReleaseStatus.assetDownloadError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Failed to download: ${state.errorMessage}',
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                switch (state.status) {
                  case GitHubReleaseStatus.initial:
                    return const SizedBox.shrink();
                  case GitHubReleaseStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case GitHubReleaseStatus.error:
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SelectableText(
                          state.errorMessage ?? 'Unknown error',
                        ),
                      ),
                    );
                  case GitHubReleaseStatus.loaded:
                  case GitHubReleaseStatus.assetDownloadSuccess:
                    return Column(
                      children: [
                        ReleaseInfoCard(release: state.release!),
                        const SizedBox(height: 16),
                        AssetsList(
                          assets: state.release!.assets,
                          onDownload: cubit.downloadAsset,
                        ),
                      ],
                    );
                  case GitHubReleaseStatus.assetDownloading:
                    return Column(
                      children: [
                        ReleaseInfoCard(release: state.release!),
                        const SizedBox(height: 16),
                        AssetsList(
                          assets: state.release!.assets,
                          onDownload: cubit.downloadAsset,
                          downloadingAsset: state.downloadingAssetName,
                        ),
                      ],
                    );
                  case GitHubReleaseStatus.assetDownloadError:
                    return Column(
                      children: [
                        ReleaseInfoCard(release: state.release!),
                        const SizedBox(height: 16),
                        AssetsList(
                          assets: state.release!.assets,
                          onDownload: cubit.downloadAsset,
                        ),
                      ],
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _UrlInputForm extends StatefulWidget {
  const _UrlInputForm();

  @override
  State<_UrlInputForm> createState() => _UrlInputFormState();
}

class _UrlInputFormState extends State<_UrlInputForm> {
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _fetchRelease() {
    if (_formKey.currentState!.validate()) {
      final urlText = _urlController.text.trim();

      if (urlText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a repository URL')),
        );
        return;
      }

      try {
        final uri = Uri.parse(urlText);
        context.read<GitHubReleaseCubit>().fetchRelease(uri);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid URL')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
              labelText: 'GitHub or GitLab Repository URL',
              hintText:
                  'https://github.com/owner/repo or https://gitlab.com/owner/repo',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.link),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a repository URL';
              }
              if (!value.contains('github.com') &&
                  !value.contains('gitlab.com')) {
                return 'Please enter a valid GitHub or GitLab URL';
              }
              return null;
            },
            onFieldSubmitted: (_) => _fetchRelease(),
          ),
          const SizedBox(height: 16),
          BlocBuilder<GitHubReleaseCubit, GitHubReleaseState>(
            builder: (context, state) {
              final isLoading = state.status == GitHubReleaseStatus.loading;

              return ElevatedButton(
                onPressed: isLoading ? null : _fetchRelease,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Fetch Latest Release'),
              );
            },
          ),
        ],
      ),
    );
  }
}
