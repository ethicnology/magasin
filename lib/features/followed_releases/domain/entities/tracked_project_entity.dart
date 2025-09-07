import 'package:dart_mappable/dart_mappable.dart';
import 'package:magasin/shared/domain/entities/release_entity.dart';

part 'tracked_project_entity.mapper.dart';

@MappableClass()
class TrackedProjectEntity with TrackedProjectEntityMappable {
  final String organization;
  final String project;
  final ReleaseProvider platform;
  final List<ReleaseEntity> releases;
  final ReleaseEntity? newRelease;

  TrackedProjectEntity({
    required this.organization,
    required this.project,
    required this.platform,
    required this.releases,
    required this.newRelease,
  });

  String get key => '$platform/$organization/$project';

  Uri get url => platform.url.replace(path: '/$organization/$project');
}
