import 'package:flutter/material.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/github_release_entity.dart';

class ReleaseInfoCard extends StatelessWidget {
  final GitHubReleaseEntity release;

  const ReleaseInfoCard({super.key, required this.release});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              release.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Tag: ${release.tagName}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Published: ${release.publishedAt.toLocal().toString().split('.')[0]}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (release.body.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Description:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(release.body),
            ],
          ],
        ),
      ),
    );
  }
}
