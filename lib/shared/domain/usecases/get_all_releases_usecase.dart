import 'package:Magasin/shared/domain/entities/release_entity.dart';
import 'package:Magasin/shared/domain/repositories/db_release_repository.dart';

class GetAllReleasesUsecase {
  final _dbReleaseRepository = DbReleaseRepository();

  GetAllReleasesUsecase();

  Future<List<ReleaseEntity>> call() async {
    return await _dbReleaseRepository.fetch();
  }
}
