import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magasin/utils.dart';
import '../cubit/cubit.dart';
import '../cubit/state.dart';
import 'release_details_page.dart';

class SearchReleasePage extends StatelessWidget {
  const SearchReleasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find a Release')),
      body: BlocListener<LatestReleaseCubit, LatestReleaseState>(
        listener: (context, state) {
          if (state.release != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (newContext) => BlocProvider<LatestReleaseCubit>.value(
                  value: context.read<LatestReleaseCubit>(),
                  child: ReleaseDetailsPage(release: state.release!),
                ),
              ),
            );
          }
        },
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [_UrlInputForm()],
          ),
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
        if (!urlText.contains('://')) {
          _urlController.text = 'https://$urlText';
        }
        var uri = Uri.parse(_urlController.text);

        context.read<LatestReleaseCubit>().fetchRelease(uri);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid URL')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select((LatestReleaseCubit cubit) => cubit.state);

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
              labelText: 'Github or GitLab Repository URL',
              hintText: 'https://github.com/owner/repo',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.link),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a repository URL';
              }
              final uri = Uri.parse(value);
              if (uri.isGitHub && uri.isGitLab) {
                return 'Please enter a valid Github or GitLab URL';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: _fetchRelease,
            child: const Text('Fetch Latest Release'),
          ),
          if (state.error != null) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SelectableText(state.error!.message),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
