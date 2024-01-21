import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/crud/notes_service.dart';

import '../../constants/routes.dart';
import '../../enums/menu_action.dart';

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

  // @override
  // void dispose() {
  //   _noteService.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(newNoteRoute);
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
                          return ListView.builder(
                            itemCount: allNotes.length,
                            itemBuilder: (context, index) {
                              final note = allNotes[index];
                              return ListTile(
                                title: Text(
                                  note.text,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          );
                          print(allNotes);
                          return const Text('Go all the notes');
                        }
                        return const Text('Waiting for all notes...');
                      default :
                        return const CircularProgressIndicator();
                    }
                  },
              );
              return const Text('Your notes will appear here');
            default: return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(onPressed: () {Navigator.of(context).pop(false);},child: const Text('Cancel')),
            TextButton(onPressed: () {Navigator.of(context).pop(true);},child: const Text('Log out')),
          ],
        );
      }
  )
      .then((value) => value ?? false);
}