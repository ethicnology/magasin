import 'package:flutter/material.dart';
import 'package:Magasin/app.dart';
import 'package:Magasin/features/followed_releases/presentation/followed_releases_page.dart';

import 'theme.dart';

void main() async {
  await App.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magasin',
      theme: AppTheme.darkTheme,
      home: const FollowedReleasesPage(),
    );
  }
}
