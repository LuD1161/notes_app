import 'package:flutter/material.dart';
import 'package:pass_list/models/note.dart';
import 'package:pass_list/utils/databaseHelper.dart';

// https://stackoverflow.com/a/56713184
class NotesProvider with ChangeNotifier {
  DatabaseHelper databaseHelper;
  List<Note> _notes;
  int count = 0;
  // get updateListView;

  List<Note> get list => _notes;

  NotesProvider() {

    databaseHelper = DatabaseHelper();
    // Pi: If the list is empty please fetch. otherwise leave it.
    if (_notes == null) {
      getNotes();
    }
  }

  void setNotes(List<Note> notesList) {
    _notes = notesList;
    notifyListeners();
  }

  void addToNotes(Note note){
    _notes.add(note);
    notifyListeners();
  }

  void getNotes() async {
    await databaseHelper.initializeDatabase();
    setNotes( await databaseHelper.getNotes() );
  }

  void insertNote(Note note) async {

    if(await databaseHelper.insertNote(note) > 0){
      addToNotes(note);
    }

  }

  // Pi: not used so i have commented out for readablitity
  // void updateNote(Note note) async {
  //   await databaseHelper.updateNote(note);
  //   setNotes(await getNotes());
  // }

  // Pi: on Dismiss, if unsuccessul return a false bool.
  Future<bool> deleteNote(int noteId) async {
    var isSuccessfulInt = await databaseHelper.deleteNote(noteId);
    if( isSuccessfulInt >= 0){
      _notes.removeWhere((note) => note.id == noteId);
      return true;    
    }
    return false;
  }
}
