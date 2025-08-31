import 'package:dart_mappable/dart_mappable.dart';

part 'asset_entity.mapper.dart';

@MappableClass()
class AssetEntity with AssetEntityMappable {
  final String name;
  final Uri url;

  const AssetEntity({required this.name, required this.url});

  static final fromMap = AssetEntityMapper.fromMap;
  static final fromJson = AssetEntityMapper.fromJson;
}
