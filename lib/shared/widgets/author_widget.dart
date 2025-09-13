import 'package:flutter/material.dart';
import 'package:magasin/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthorWidget extends StatelessWidget {
  final String username;
  final UriEntity profileUrl;
  const AuthorWidget({
    super.key,
    required this.username,
    required this.profileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () =>
          launchUrl(profileUrl, mode: LaunchMode.externalApplication),
      icon: Icon(Icons.person),
      label: Text(username),
    );
  }
}
