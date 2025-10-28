import '../../domain/entities/app_config.dart';

class AppConfigDto {
  final String? ownerProjectLinkId;
  final String wsPath;

  AppConfigDto({required this.ownerProjectLinkId, required this.wsPath});

  factory AppConfigDto.fromJson(Map<String, dynamic> j) => AppConfigDto(
        ownerProjectLinkId: j['ownerProjectLinkId'],
        wsPath: j['wsPath'] ?? '',
      );

  AppConfig toEntity() =>
      AppConfig(ownerProjectLinkId: ownerProjectLinkId, wsPath: wsPath);
}
