part of 'contacts_bloc.dart';

@freezed
sealed class ContactsEvent with _$ContactsEvent {
  const factory ContactsEvent.loadContacts() = _LoadContacts;
  const factory ContactsEvent.loadContactsNextPage() = _LoadContactsNextPage;
  const factory ContactsEvent.searchContacts(String searchTerm) =
      _SearchContacts;
}
