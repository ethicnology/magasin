import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

class UriMapper extends SimpleMapper<Uri> {
  const UriMapper();

  @override
  Uri decode(dynamic value) => Uri.parse(value as String);

  @override
  dynamic encode(Uri self) => self.toString();
}

typedef UriEntity = Uri;

extension UriExtensions on UriEntity {
  bool get isGitHub => host == 'github.com';
  bool get isGitLab => host == 'gitlab.com';
}

({String owner, String repo}) extractOwnerAndRepo(Uri url) {
  final pathSegments = url.pathSegments;
  if (pathSegments.length < 2) {
    throw Exception('Invalid GitHub repository URL');
  }

  return (owner: pathSegments[0], repo: pathSegments[1]);
}

void goto(BuildContext context, Widget page, {bool canPop = true}) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => page),
    (route) => canPop,
  );
}
