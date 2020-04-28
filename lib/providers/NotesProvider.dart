import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pass_list/models/note.dart';
import 'package:pass_list/utils/database_helper.dart';
import 'package:pass_list/utils/noteHelper.dart';

class NotesProvider with ChangeNotifier {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Note> _noteList, asyncNoteList;
  int _count = 0;
  bool _asyncCompleted = false;

  UnmodifiableListView<Note> get allNotes => UnmodifiableListView(_noteList);

  getNotes() async {
    await _databaseHelper.initializeDatabase();
    List<Note> noteList = await _databaseHelper.getNoteList();
    this._noteList = noteList;
    this._count = noteList.length;
    notifyListeners();
  }

  UnmodifiableListView<Note> get allAsyncNotes =>
      UnmodifiableListView(asyncNoteList);
  getAllAsyncNotes() async {
    List<Note> asyncNoteList = [];
    for (var note in this._noteList) {
      asyncNoteList.add(await asyncFunction(note));
    }
    this.asyncNoteList = asyncNoteList;
    this._asyncCompleted = true;
    notifyListeners();
  }

  int get count => _count;
  bool get asyncCompleted => _asyncCompleted;

  void addNote(BuildContext context, Note note) async {
    var result;
    if (note.id != null) {
      result = await _databaseHelper.updateNote(note);
    } else {
      result = await _databaseHelper.insertNote(note);
    }
    if (result != 0) {
      if (note.id != null) {
        showSnackBar(context, '${note.title} Updated');
      } else {
        showSnackBar(context, '${note.title} Created');
      }
    } else {
      showSnackBar(context, 'Some error occurred');
    }
    notifyListeners();
  }

  void deleteNote(BuildContext context, Note note) async {
    if (note.id == null) {
      showSnackBar(context, 'No note was deleted');
      return;
    }

    int result = await _databaseHelper.deleteNote(note.id);
    if (result != 0) {
      showSnackBar(context, 'Note Deleted Successfully');
    } else {
      showSnackBar(context, 'Error Occurred while deleting note');
    }
    notifyListeners();
  }
}