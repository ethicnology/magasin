import 'package:dart_mappable/dart_mappable.dart';

class UriMapper extends SimpleMapper<Uri> {
  const UriMapper();

  @override
  Uri decode(dynamic value) => Uri.parse(value as String);

  @override
  dynamic encode(Uri self) => self.toString();
}

extension UriExtensions on Uri {
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
