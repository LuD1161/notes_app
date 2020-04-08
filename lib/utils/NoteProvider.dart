import 'package:flutter/material.dart';
import 'package:pass_list/models/note.dart';
import 'package:pass_list/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteProvider with ChangeNotifier {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList = List<Note>();
  int count = 0;
  // get updateListView;

  NoteProvider() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
          this.noteList = noteList;
          this.count = noteList.length;
      });
    });
  }

  Future<int> updateNote(note) async{
    var result = await databaseHelper.updateNote(note);
    notifyListeners();
    return result;
  }

  Future<int> insertNote(note) async{
    var result =  await databaseHelper.insertNote(note);
    notifyListeners();
    return result;
  }
}