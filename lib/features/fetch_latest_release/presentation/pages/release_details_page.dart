import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/release_entity.dart';
import 'package:magasin/features/fetch_latest_release/presentation/cubit/cubit.dart';
import 'package:magasin/features/fetch_latest_release/presentation/widgets/release_info_card.dart';
import 'package:magasin/features/fetch_latest_release/presentation/widgets/assets_list.dart';

class ReleaseDetailsPage extends StatelessWidget {
  final ReleaseEntity release;

  const ReleaseDetailsPage({super.key, required this.release});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LatestReleaseCubit>();

    return Scaffold(
      appBar: AppBar(title: Text(release.name), actions: [

        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ReleaseInfoCard(release: release),
            ElevatedButton(
              onPressed: () => cubit.followFuturesReleases(release),
              child: const Text('Follow Futures Releases'),
            ),
            AssetsList(assets: release.assets, onDownload: cubit.downloadAsset),
          ],
        ),
      ),
    );
  }
}
