import 'package:flutter/material.dart';
import 'package:pass_list/models/note.dart';
import 'package:pass_list/providers/NotesProvider.dart';
import 'package:pass_list/screens/notePage.dart';
import 'package:provider/provider.dart';

class NotePageScreen extends StatefulWidget {
  NotePageScreen();

  @override
  NotePageScreenState createState() => NotePageScreenState();
}

class NotePageScreenState extends State<NotePageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    Provider.of<NotesProvider>(context, listen: false).getAllDecryptedNotes();
    return Scaffold(
        key: _scaffoldKey,
        body: Provider.of<NotesProvider>(context).decrypted
            ? NotePage()
            : Container(
                child: Center(
                  child: Text("Add a new Note"),
                ),
              ));
  }
}
