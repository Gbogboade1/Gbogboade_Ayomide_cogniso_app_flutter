import '../../../data/models/user_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contacts_model.freezed.dart';
part 'contacts_model.g.dart';

@freezed
class ContactsModel with _$ContactsModel {
  const factory ContactsModel({
    @Default([]) List<UserData> allUsers,
    @Default([]) List<UserData> searchResult,
    @Default('') String searchTerm,
    @Default(0) int currentIndex,
    @Default(0) int currentSearchIndex,
  }) = _ContactsModel;

  factory ContactsModel.fromJson(Map<String, dynamic> json) =>
      _$ContactsModelFromJson(json);
}
