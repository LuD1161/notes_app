import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pass_list/utils/notesProvider.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';

class CreateNote extends StatefulWidget {
  @override
  CreateNoteState createState() => CreateNoteState();
}

class CreateNoteState extends State<CreateNote> {
  TextEditingController titleController = TextEditingController();
  CreateNoteState();

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    TextStyle textStyle = Theme.of(context).textTheme.title; // Pi: deprecated style

    // Prefilled values for text controllers
    titleController.text = '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(children: <Widget>[
          // Title - First Element
          Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: TextField(
              style: textStyle,
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title', labelStyle: textStyle, border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
            ),
          ),
          // Save - Second Element
          Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Row(children: <Widget>[
              // Save Button : First Element
              Expanded(
                child: RaisedButton(
                  color: Theme.of(context).primaryColorDark,
                  textColor: Theme.of(context).primaryColorLight,
                  child: Text(
                    "Save",
                    textScaleFactor: 1.5,
                  ),
                  onPressed: () {
                    setState(
                      () {
                        // debugPrint("Save Button Pressed");
                        _save(notesProvider, context); // Pi: so i passing the context so i can call provider. not optimal, it works.
                      },
                    );
                  },
                ),
              ),
            ]),
          )
        ]),
      ),
    );
  }

  // Save data to the database
  void _save(NotesProvider notesProvider, BuildContext context) async {
    notesProvider.insertNote(
      Note(
        title: titleController.text,
        description: titleController.text,
        date: DateFormat.yMMMd().format(DateTime.now()),
      ),
    );
    Navigator.pop(context);
  }

  // Pi: wrong type of dialog. A snackbar is better. Non-blocking Ui
  // void _showAlertDialog(String title, String message, BuildContext context) {
  //   AlertDialog alertDialog = AlertDialog(
  //     title: Text(title),
  //     content: Text(message),
  //   );
  //   showDialog(context: context, builder: (_) => alertDialog);
  // }


  // Pi: Not being used so it's commented out
  // void _delete(Note note, NotesProvider notesProvider, BuildContext context) async {
  //   Navigator.pop(context, true);
  //   // Case 1 : If a user is trying to delete the NEW Note i.e. (s)he has come to
  //   // the detail page by pressing the FAB of NoteList page.
  //   if (note.id == null) {
  //     _showAlertDialog('Status', 'No Note was deleted', context);
  //     return;
  //   }
  //   // Case 2 : User is trying to delete the old note that has a VALID ID.
  //   int result = await notesProvider.deleteNote(note.id);
  //   if (result != 0) {
  //     _showAlertDialog('Status', 'Note Deleted successfully', context);
  //   } else {
  //     _showAlertDialog('Status', 'Error occurred in deleting the note', context);
  //   }
  // }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
