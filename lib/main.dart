import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:magasin/database/database.dart';
import 'package:magasin/features/followed_releases/presentation/followed_releases_page.dart';
import 'package:magasin/utils.dart';
import 'theme.dart';

void init() {
  WidgetsFlutterBinding.ensureInitialized();

  MapperContainer.globals.use(UriMapper());

  initDatabase();
}

void main() {
  init();

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
