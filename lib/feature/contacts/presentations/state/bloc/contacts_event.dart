part of 'contacts_bloc.dart';

@freezed
sealed class ContactsEvent with _$ContactsEvent {
  const factory ContactsEvent.clearSearchTerm() = _ClearSearchTerm;
  const factory ContactsEvent.loadContactsPage(int page) = _LoadContactsPage;
  const factory ContactsEvent.searchContacts(String searchTerm) =
      _SearchContacts;
}
