part of 'contacts_bloc.dart';

@freezed
class ContactsState with _$ContactsState {
  const factory ContactsState.initial({
    @Default(ContactsModel()) ContactsModel model,
  }) = _Initial;
  const factory ContactsState.contactsLoaded(ContactsModel model) =
      ContactsLoaded;
  const factory ContactsState.contactsLoading(ContactsModel model) =
      ContactsLoading;
  const factory ContactsState.contactsLoadingFailed(
    ContactsModel model,
    String errorMessage,
  ) = ContactsLoadingFailed;
  const factory ContactsState.contactsSearchFound(ContactsModel model) =
      ContactsSearchFound;
  const factory ContactsState.contactsSearchFailed(
    ContactsModel model,
    String errorMessage,
  ) = ContactsSearchFailed;
}
