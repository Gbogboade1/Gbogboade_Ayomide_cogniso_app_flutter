import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../data/models/user_data.dart';
import '../state/bloc/contacts_bloc.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  late TextEditingController controller;
  late ScrollController scrollController;
  var listState = PagingState<int, UserData>();

  final searchDebouncer = Debouncer<String>(const Duration(milliseconds: 500), initialValue: '');

  @override
  void initState() {
    controller = TextEditingController();
    scrollController = ScrollController();
    super.initState();

    controller.addListener(_handleTextChange);

    searchDebouncer.values.listen((search) {
      if (mounted && search.isNotEmpty) {
        context.read<ContactsBloc>().add(ContactsEvent.searchContacts(search));
      }
    });
  }

  void _handleTextChange() {
    searchDebouncer.value = controller.text.trim();
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    searchDebouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ContactsBloc>();
    return BlocConsumer<ContactsBloc, ContactsState>(
      listener: (context, state) {
        if (state is ContactsSearchFailed) {
          listState = listState.copyWith(isLoading: false, error: state.errorMessage);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              behavior: SnackBarBehavior.fixed,
              duration: const Duration(seconds: 3),
            ),
          );
        }

        if (state is ContactsLoading) {
          listState = listState.copyWith(isLoading: true);
        }
        if (state is ContactsLoadingFailed) {
          listState = listState.copyWith(isLoading: false, error: state.errorMessage);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              behavior: SnackBarBehavior.fixed,
              duration: const Duration(seconds: 3),
            ),
          );
        }

        if (state is ContactsSearchFound) {
          listState = listState.copyWith().copyWith(
            isLoading: false,
            hasNextPage: state.result.isNotEmpty,
            keys: [state.model.currentSearchIndex],
            pages: [state.result],
          );
        }

        if (state is ContactsSearchFound) {
          listState = PagingState<int, UserData>();
          listState = listState.copyWith(
            isLoading: false,
            hasNextPage: state.result.isNotEmpty,
            keys: [...?listState.keys, state.model.currentSearchIndex],
            pages: [...?listState.pages, state.result],
          );
        }

        if (state is ContactsLoaded) {
          listState = listState.copyWith(
            isLoading: false,
            hasNextPage: state.model.allUsers.isNotEmpty,
            keys: [...?listState.keys, state.model.currentIndex],
            pages: [...?listState.pages, state.model.allUsers],
          );
        }

        if (state is ContactsSearchFoundNextPage) {
          listState = listState.copyWith(
            isLoading: false,
            hasNextPage: state.model.allUsers.isNotEmpty,
            keys: [...?listState.keys, state.model.currentSearchIndex],
            pages: [...?listState.pages, state.result],
          );
        }

        if (state is ContactsSearchCleared) {
          scrollController.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.linear);
          listState = listState.copyWith(
            isLoading: false,
            keys: [state.model.currentIndex],
            pages: [state.model.allUsers],
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Contacts By Gbogboade')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    prefixIcon: const Icon(CupertinoIcons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    suffix: InkWell(
                      onTap: () {
                        bloc.add(const ContactsEvent.clearSearchTerm());
                        controller.clear();
                      },
                      child: const Icon(Icons.cancel),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: PagedListView<int, UserData>.separated(
                    scrollController: scrollController,
                    state: listState,
                    fetchNextPage: () {
                      if (listState.isLoading) return;
                      final newKey = (listState.keys?.last ?? 0) + 1;
                      context.read<ContactsBloc>().add(ContactsEvent.loadContactsPage(newKey));
                    },
                    builderDelegate: PagedChildBuilderDelegate(
                      noMoreItemsIndicatorBuilder: (context) => const Center(child: Text('End of List')),
                      noItemsFoundIndicatorBuilder: (context) => const Center(child: Text('No contacts found')),
                      firstPageErrorIndicatorBuilder:
                          (context) => Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${listState.error}'),
                                const SizedBox(height: 16),
                                MaterialButton(
                                  color: Colors.grey,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    final newKey = (listState.keys?.last ?? 0) + 1;
                                    context.read<ContactsBloc>().add(ContactsEvent.loadContactsPage(newKey));
                                  },
                                  child: const Text('Try Again'),
                                ),
                              ],
                            ),
                          ),
                      newPageErrorIndicatorBuilder:
                          (context) => Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${listState.error}'),
                                const SizedBox(height: 16),
                                MaterialButton(
                                  color: Colors.grey,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    final newKey = (listState.keys?.last ?? 0) + 1;
                                    context.read<ContactsBloc>().add(ContactsEvent.loadContactsPage(newKey));
                                  },
                                  child: const Text('Try Again'),
                                ),
                              ],
                            ),
                          ),
                      newPageProgressIndicatorBuilder:
                          (context) => const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: LinearProgressIndicator(),
                          ),
                      itemBuilder:
                          (context, contact, index) => Card(
                            // elevation: 5,
                            // decoration: const BoxDecoration(
                            //   color: Colors.white,
                            //   boxShadow: [BoxShadow(color: Colors.black)],
                            // ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: contact.image,

                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                          shape: BoxShape.circle,
                                        ),
                                      );
                                    },
                                    height: 40,
                                    width: 40,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${contact.firstName} ${contact.lastName}',
                                          style: const TextStyle(fontWeight: FontWeight.w700),
                                        ),
                                        Text(contact.email),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ),
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
