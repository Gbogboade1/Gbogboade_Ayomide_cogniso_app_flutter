import 'package:cogniso_app/feature/contacts/domain/contacts_service.dart';
import 'package:cogniso_app/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
        _LoadContacts() => _onLoadContacts(emit),
        _LoadContactsNextPage() =>
          state.model.searchTerm.trim().isEmpty
              ? _onLoadContactsNextPage(emit)
              : _onLoadContactsSearchNextPage,
        _SearchContacts(:final searchTerm) => _onSearchContacts(
          emit,
          searchTerm,
        ),
      };
    });
  }

  _onSearchContacts(Emitter<ContactsState> emit, String searchTerm) async {
    final term = searchTerm.trim().toLowerCase();
    final filteredContacts =
        state.model.allUsers
            .where((contact) => contact.email.toLowerCase().contains(term))
            .toList();

    emit(
      ContactsState.contactsLoading(
        state.model.copyWith(
          searchResult: filteredContacts,
          searchTerm: searchTerm.trim(),
        ),
      ),
    );

    final result = await _contactsService.getContacts(
      skip: state.model.allUsers.length,
    );
    result.fold(
      (errorMessage) {
        emit(
          ContactsState.contactsSearchFailed(
            state.model.copyWith(),
            errorMessage,
          ),
        );
      },
      (data) {
        final contacts = data.users;
        emit(
          ContactsState.contactsSearchFound(
            state.model.copyWith(
              allUsers: [...state.model.allUsers, ...contacts],
            ),
          ),
        );
      },
    );
  }

  _onLoadContactsNextPage(Emitter<ContactsState> emit) async {
    emit(ContactsState.contactsLoading(state.model.copyWith()));
    final result = await _contactsService.getContacts(
      skip: state.model.allUsers.length,
    );
    result.fold(
      (errorMessage) {
        emit(
          ContactsState.contactsLoadingFailed(
            state.model.copyWith(),
            errorMessage,
          ),
        );
      },
      (data) {
        final contacts = data.users;
        emit(
          ContactsState.contactsLoaded(
            state.model.copyWith(
              allUsers: [...state.model.allUsers, ...contacts],
            ),
          ),
        );
      },
    );
  }

  _onLoadContactsSearchNextPage(Emitter<ContactsState> emit) async {
    emit(ContactsState.contactsLoading(state.model.copyWith()));
    final result = await _contactsService.searchContacts(
      searchTerm: state.model.searchTerm,
      skip: state.model.allUsers.length,
    );
    result.fold(
      (errorMessage) {
        emit(
          ContactsState.contactsLoadingFailed(
            state.model.copyWith(),
            errorMessage,
          ),
        );
      },
      (data) {
        final contacts = data.users;
        emit(
          ContactsState.contactsSearchFound(
            state.model.copyWith(
              searchResult: [...state.model.searchResult, ...contacts],
            ),
          ),
        );
      },
    );
  }

  _onLoadContacts(Emitter<ContactsState> emit) async {
    emit(ContactsState.contactsLoading(state.model.copyWith()));

    final result = await _contactsService.getContacts();
    result.fold(
      (errorMessage) {
        emit(
          ContactsState.contactsLoadingFailed(
            state.model.copyWith(),
            errorMessage,
          ),
        );
      },
      (data) {
        final contacts = data.users;
        emit(
          ContactsState.contactsLoaded(
            state.model.copyWith(allUsers: contacts),
          ),
        );
      },
    );
  }
}
