import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_data.dart';

part 'get_contact_response.freezed.dart';
part 'get_contact_response.g.dart';

@freezed
class GetContactResponse with _$GetContactResponse {
  factory GetContactResponse({
    @Default([]) List<UserData> users,
    @Default(0) int total,
    @Default(0) int skip,
    @Default(0) int limit,
  }) = _GetContactResponse;

  factory GetContactResponse.fromJson(Map<String, dynamic> json) =>
      _$GetContactResponseFromJson(json);
}
