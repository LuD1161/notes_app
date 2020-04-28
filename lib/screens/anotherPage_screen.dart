import 'package:flutter/material.dart';
import 'package:pass_list/models/note.dart';
import 'package:pass_list/providers/NotesProvider.dart';
import 'package:pass_list/screens/anotherPage.dart';
import 'package:provider/provider.dart';

class AnotherPageScreen extends StatefulWidget {
  AnotherPageScreen();

  @override
  NotePageScreenState createState() => NotePageScreenState();
}

class NotePageScreenState extends State<AnotherPageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    Provider.of<NotesProvider>(context).getAllAsyncNotes();
    return Scaffold(
        key: _scaffoldKey,
        body: Provider.of<NotesProvider>(context).asyncCompleted
            ? AnotherPage()
            : Container(
                child: Center(
                  child: Text("Add a new Note"),
                ),
              ));
  }
}
