import 'package:flutter/material.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/release_entity.dart';

class ReleaseInfoCard extends StatelessWidget {
  final ReleaseEntity release;

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
              'Tag: ${release.tag}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Published: ${release.publishedAt.toLocal().toString().split('.')[0]}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Platform: ${release.platform.name.toUpperCase()}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            if (release.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Description:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(release.description),
            ],
          ],
        ),
      ),
    );
  }
}
