import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magasin/features/show_release/release_details_page.dart';

import 'package:magasin/features/followed_releases/presentation/cubit/cubit.dart';
import 'package:magasin/features/followed_releases/presentation/cubit/state.dart';
import 'package:magasin/features/followed_releases/presentation/tracked_project_card.dart';
import 'package:magasin/features/fetch_latest_release/presentation/search_release_page.dart';
import 'package:magasin/utils.dart';

class FollowedReleasesPage extends StatelessWidget {
  const FollowedReleasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FollowedReleasesCubit(),
      child: const FollowedReleasesView(),
    );
  }
}

class FollowedReleasesView extends StatelessWidget {
  const FollowedReleasesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Followed Releases')),
      body: BlocConsumer<FollowedReleasesCubit, FollowedReleasesState>(
        listener: (context, state) {
          final cubit = context.read<FollowedReleasesCubit>();
          final countNewReleases = state.countNewReleases;

          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Dismiss',
                  onPressed: cubit.clearError,
                ),
              ),
            );
          }

          if (countNewReleases > 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Found $countNewReleases new release(s)!'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<FollowedReleasesCubit>();

          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.trackedProjects.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No followed projects',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Start following projects by searching for releases',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  TextButton.icon(
                    onPressed: () => goto(context, const SearchReleasePage()),
                    icon: const Icon(Icons.search),
                    label: const Text('Search Releases'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: cubit.loadTrackedProjects,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.trackedProjects.length,
              itemBuilder: (context, index) {
                final project = state.trackedProjects.values.toList()[index];

                return InkWell(
                  onLongPress: () => _showDeleteDialog(context, project),
                  onTap: () {
                    final release = project.newRelease != null
                        ? project.newRelease!
                        : project.releases.last;

                    goto(context, ReleaseDetailsPage(release: release));
                  },
                  child: TrackedProjectCard(project: project),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goto(context, const SearchReleasePage()),
        tooltip: 'Follow new project',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, project) {
    final cubit = context.read<FollowedReleasesCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Unfollow Project'),
        content: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              const TextSpan(text: 'Are you sure you want to unfollow '),
              TextSpan(
                text: '${project.organization}/${project.project}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ' ?\n\n'),
              TextSpan(
                text:
                    'This will remove ${project.releases.length} tracked releases for this project.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cubit.unfollowProject(project);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Unfollow'),
          ),
        ],
      ),
    );
  }
}
