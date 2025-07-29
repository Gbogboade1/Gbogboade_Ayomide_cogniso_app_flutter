import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_app/features/contacts/data/models/user_data.dart';

import '../../../domain/contacts_service.dart';
import '../../../../../injectable.dart';
import '../entities/contacts_model.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';
part 'contacts_bloc.freezed.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final ContactsService _contactsService;
  ContactsBloc({ContactsService? contactsService})
    : _contactsService = contactsService ?? getIt(),
      super(const _Initial()) {
    on<ContactsEvent>((event, emit) async {
      await switch (event) {
        _ClearSearchTerm() => _onClearSearchTerm(emit),
        _LoadContactsPage(:final page) =>
          state.model.searchTerm.trim().isEmpty
              ? _onLoadContactsNextPage(emit, page)
              : _onLoadContactsSearchNextPage(emit, page),
        _SearchContacts(:final searchTerm) => _onSearchContacts(emit, searchTerm),
      };
    });
  }

  _onLoadContactsNextPage(Emitter<ContactsState> emit, int page) async {
    emit(ContactsState.contactsLoading(state.model.copyWith()));
    final result = await _contactsService.getContacts(skip: 10 * (page - 1));
    result.fold(
      (errorMessage) {
        emit(ContactsState.contactsLoadingFailed(state.model.copyWith(), errorMessage));
      },
      (data) {
        final contacts = data.users;
        emit(
          ContactsState.contactsLoaded(
            state.model.copyWith(allUsers: [...state.model.allUsers, ...contacts], currentIndex: page),
          ),
        );
      },
    );
  }

  _onSearchContacts(Emitter<ContactsState> emit, String searchTerm) async {
    emit(ContactsState.contactsLoading(state.model.copyWith(searchTerm: searchTerm.trim().toLowerCase())));

    final result = await _contactsService.getContacts(skip: state.model.allUsers.length);
    result.fold(
      (errorMessage) {
        emit(ContactsState.contactsSearchFailed(state.model.copyWith(), errorMessage));
      },
      (data) {
        final contacts = data.users;
        emit(ContactsState.contactsSearchFound(state.model.copyWith(currentSearchIndex: 0), contacts));
      },
    );
  }

  _onLoadContactsSearchNextPage(Emitter<ContactsState> emit, int page) async {
    emit(ContactsState.contactsLoading(state.model.copyWith()));
    final result = await _contactsService.searchContacts(searchTerm: state.model.searchTerm, skip: 10 * (page - 1));
    result.fold(
      (errorMessage) {
        emit(ContactsState.contactsSearchFailed(state.model.copyWith(), errorMessage));
      },
      (data) {
        final contacts = data.users;
        emit(ContactsState.contactsSearchFoundNextPage(state.model.copyWith(currentSearchIndex: page), contacts));
      },
    );
  }

  _onClearSearchTerm(Emitter<ContactsState> emit) async {
    emit(ContactsState.searchCleared(state.model.copyWith(searchTerm: '', currentSearchIndex: 1)));
  }
}
