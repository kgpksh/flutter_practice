import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/crud/notes_service.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';

import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../utilities/dialog/logout_dialog.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late final NoteService _noteService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _noteService = NoteService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuActions>(
            onSelected: (value) async {
              switch (value) {
                case MenuActions.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if(shouldLogout) {
                    AuthService.firebase().logOut();
                    if(!context.mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                          (_) => false,
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuActions>(
                  value: MenuActions.logout,
                  child: Text('Log out'),
                ),
              ];
            },)
        ],
      ),
      body: FutureBuilder(
        future: _noteService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                  stream: _noteService.allNotes,
                  builder: (context, snapshot) {
                    switch(snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active :
                        if(snapshot.hasData) {
                          final allNotes = snapshot.data as List<DatabaseNote>;
                          return NotesListView(
                              notes: allNotes,
                              onDeleteNote: (note) async {
                                await _noteService.deleteNote(id: note.id);
                              },
                            onTap: (note) {
                              Navigator.of(context).pushNamed(
                                createOrUpdateNoteRoute,
                                arguments: note,
                              );
                            },
                          );
                        }
                        return const Text('Waiting for all notes...');
                      default :
                        return const CircularProgressIndicator();
                    }
                  },
              );
            default: return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}