import 'package:flutter/material.dart';
import 'package:pass_list/models/note.dart';
import 'package:pass_list/providers/NotesProvider.dart';
import 'package:pass_list/utils/database_helper.dart';
import 'package:pass_list/utils/noteHelper.dart';
import 'package:pass_list/widgets/noteCard.dart';
import 'package:pass_list/widgets/noteList.dart';
import 'package:provider/provider.dart';

class NoteList extends StatefulWidget {
  NoteList();

  @override
  NoteListState createState() => NoteListState();
}

class NoteListState extends State<NoteList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    Provider.of<NotesProvider>(context).getNotes();
    return Scaffold(
        key: _scaffoldKey,
        body: Provider.of<NotesProvider>(context).count > 0
            ? NoteListScreen(_scaffoldKey)
            : CircularProgressIndicator());
  }
}
