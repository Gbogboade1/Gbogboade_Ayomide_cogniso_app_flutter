import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:debounce_throttle/debounce_throttle.dart';

import '../state/bloc/contacts_bloc.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  late ScrollController scrollController;
  late TextEditingController controller;

  final searchDebouncer = Debouncer<String>(const Duration(milliseconds: 500), initialValue: '');

  @override
  void initState() {
    scrollController = ScrollController();
    controller = TextEditingController();
    super.initState();

    scrollController.addListener(_handleScroll);
    controller.addListener(_handleTextChange);

    searchDebouncer.values.listen((search) {
      if (mounted) {
        context.read<ContactsBloc>().add(ContactsEvent.searchContacts(search));
      }
    });
  }

  void _handleTextChange() {
    searchDebouncer.value = controller.text.trim();
  }

  void _handleScroll() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      context.read<ContactsBloc>().add(const ContactsEvent.loadContactsNextPage());
    }
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    controller.dispose();
    searchDebouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactsBloc, ContactsState>(
      listener: (context, state) {
        if (state is ContactsSearchFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              behavior: SnackBarBehavior.fixed,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        if (state is ContactsLoadingFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              behavior: SnackBarBehavior.fixed,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        final contacts = switch (state) {
          ContactsSearchFound _ when state.model.searchTerm.isEmpty => state.model.allUsers,
          ContactsLoading _ when state.model.searchTerm.isEmpty => state.model.allUsers,
          ContactsLoading _ when state.model.searchTerm.isNotEmpty => state.model.searchResult,
          ContactsSearchFailed _ when state.model.searchTerm.isNotEmpty => state.model.searchResult,
          _ => state.model.allUsers,
        };
        return Scaffold(
          appBar: AppBar(title: const Text('Contacts By Gbogboade')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                    prefixIcon: Icon(CupertinoIcons.search),
                    border: OutlineInputBorder(),
                  ),
                ),

                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  child: switch (state) {
                    ContactsLoading _ when contacts.isNotEmpty => Container(
                      height: 16,

                      padding: const EdgeInsets.only(bottom: 6, top: 6),
                      child: const LinearProgressIndicator(),
                    ),
                    _ => const SizedBox(height: 16),
                  },
                ),
                Expanded(
                  child:
                      contacts.isEmpty
                          ? const Center(child: CircularProgressIndicator.adaptive())
                          : ListView.separated(
                            controller: scrollController,
                            itemBuilder: (context, index) {
                              final contact = contacts[index];
                              return Container(
                                decoration: const BoxDecoration(),
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
                                      height: 32,
                                      width: 32,
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
                              );
                            },
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemCount: contacts.length,
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
