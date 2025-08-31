import 'package:dart_mappable/dart_mappable.dart';
import 'package:magasin/errors.dart';
import 'package:magasin/features/fetch_latest_release/domain/entities/release_entity.dart';

part 'state.mapper.dart';

@MappableClass()
class LatestReleaseState with LatestReleaseStateMappable {
  final ReleaseEntity? release;
  final AppError? error;

  const LatestReleaseState({this.release, this.error});
}
