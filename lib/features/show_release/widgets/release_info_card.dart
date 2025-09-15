import 'package:flutter/material.dart';
import 'package:Magasin/shared/domain/entities/release_entity.dart';
import 'package:Magasin/shared/widgets/author_widget.dart';
import 'package:Magasin/theme.dart';

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
            Center(
              child: Text(
                release.publishedAt.toLocal().toString().split('.')[0],
              ),
            ),
            Text(release.tag),
            Text(release.name),
            Text(release.platform.name),

            if (release.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              SelectableText(release.description),
            ],
            const SizedBox(height: AppSizes.s),

            const SizedBox(height: AppSizes.s),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SelectableText(release.commit.substring(0, 7)),
                AuthorWidget(
                  username: release.author.username,
                  profileUrl: release.author.profileUrl,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
