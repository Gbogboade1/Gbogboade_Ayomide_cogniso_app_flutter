import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_search_dto.freezed.dart';
part 'contact_search_dto.g.dart';

@freezed
class ContactSearchDto with _$ContactSearchDto {
  const factory ContactSearchDto({
    @Default('') String search,
    @Default(10) int limit,
    @Default(0) int skip,
  }) = _ContactSearchDto;

  factory ContactSearchDto.fromJson(Map<String, dynamic> json) =>
      _$ContactSearchDtoFromJson(json);
}
