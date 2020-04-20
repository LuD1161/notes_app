import 'package:flutter/material.dart';
import 'package:pass_list/models/note.dart';
import 'package:pass_list/screens/note_detail.dart';
import 'package:pass_list/utils/database_helper.dart';

final DatabaseHelper databaseHelper = DatabaseHelper();

Color getPriorityColor(int priority) {
  switch (priority) {
    case 1:
      return Colors.red;
      break;
    case 2:
      return Colors.yellow;
      break;

    default:
      return Colors.cyan;
  }
}

// Returns the priority icon
Icon getPriorityIcon(int priority) {
  switch (priority) {
    case 1:
      return Icon(Icons.play_arrow);
      break;
    case 2:
      return Icon(Icons.keyboard_arrow_right);
      break;

    default:
      return Icon(Icons.keyboard_arrow_right);
  }
}

void delete(BuildContext context, Note note) async {
  int result = await databaseHelper.deleteNote(note.id);
  if (result != 0) {
    showSnackBar(context, 'Note Deleted Successfully');
    // updateListView();
  }
}

void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  Scaffold.of(context).showSnackBar(snackBar);
}

updateListView() async {
  await databaseHelper.initializeDatabase();
  List<Note> noteListFuture = await databaseHelper.getNoteList();
  return noteListFuture;
}

showNewDialog(BuildContext context, Note note) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(note.title),
        content: new Text(note.description),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void navigateToDetail(BuildContext context, Note note, String title) async {
  await Navigator.push(context, MaterialPageRoute(builder: (context) {
    return NoteDetail(note, title);
  }));
}
