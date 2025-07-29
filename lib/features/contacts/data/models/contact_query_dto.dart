import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_query_dto.freezed.dart';
part 'contact_query_dto.g.dart';

@freezed
class ContactQueryDto with _$ContactQueryDto {
  const factory ContactQueryDto({
    @Default(10) int limit,
    @Default(0) int skip,
  }) = _ContactQueryDto;

  factory ContactQueryDto.fromJson(Map<String, dynamic> json) =>
      _$ContactQueryDtoFromJson(json);
}
