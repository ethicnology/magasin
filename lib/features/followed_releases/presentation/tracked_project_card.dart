import 'package:flutter/material.dart';
import 'package:magasin/shared/domain/entities/release_entity.dart';
import 'package:magasin/features/followed_releases/domain/entities/tracked_project_entity.dart';
import 'package:magasin/theme.dart';

class TrackedProjectCard extends StatelessWidget {
  final TrackedProjectEntity project;

  const TrackedProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    project.releases.sort((a, b) => a.publishedAt.compareTo(b.publishedAt));
    final lastestStoredRelease = project.releases.last;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.m),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(project.platform.icon, color: project.platform.color),
                const SizedBox(width: AppSizes.s),
                Expanded(
                  child: Text(
                    '${project.organization}/${project.project}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.m),
            if (project.releases.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.label, color: AppColors.grey),
                      const SizedBox(width: AppSizes.s),
                      Text(lastestStoredRelease.tag),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: AppColors.grey),
                      const SizedBox(width: AppSizes.s),
                      Text(_formatDate(project.releases.last.publishedAt)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.l),
            ],
            Wrap(
              spacing: AppSizes.s,
              children: [
                Chip(
                  label: Text('${project.releases.length} tracked releases'),
                ),
                if (project.newRelease != null)
                  Chip(
                    backgroundColor: AppColors.teal,
                    label: Text('new latest'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
