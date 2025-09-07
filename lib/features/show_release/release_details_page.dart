import 'package:flutter/material.dart';
import 'package:magasin/shared/domain/entities/release_entity.dart';
import 'package:magasin/shared/domain/usecases/download_release_asset_usecase.dart';
import 'package:magasin/shared/domain/usecases/follow_futures_releases_usecase.dart';
import 'package:magasin/features/show_release/widgets/assets_list.dart';
import 'package:magasin/features/show_release/widgets/release_info_card.dart';
import 'package:magasin/features/followed_releases/presentation/followed_releases_page.dart';
import 'package:magasin/theme.dart';
import 'package:magasin/utils.dart';

class ReleaseDetailsPage extends StatelessWidget {
  final _downloadReleaseAssetUseCase = DownloadReleaseAssetUseCase();
  final _followFuturesReleasesUseCase = FollowFuturesReleasesUseCase();
  final ReleaseEntity release;

  ReleaseDetailsPage({super.key, required this.release});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(release.name), actions: [

        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.m),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ReleaseInfoCard(release: release),
            TextButton.icon(
              onPressed: () {
                _followFuturesReleasesUseCase.call(release: release);
                goto(context, const FollowedReleasesPage(), canPop: false);
              },
              label: const Text('Follow Futures Releases'),
              icon: const Icon(Icons.add_box),
            ),
            AssetsList(
              assets: release.assets,
              onDownload: (asset) => _downloadReleaseAssetUseCase(asset: asset),
            ),
          ],
        ),
      ),
    );
  }
}
