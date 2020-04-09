import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pass_list/models/note.dart';
import 'package:pass_list/utils/NoteProvider.dart';
import 'package:provider/provider.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  NoteDetailState createState() => NoteDetailState(this.note, this.appBarTitle);
}

class NoteDetailState extends State<NoteDetail> {

  String appBarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    TextStyle textStyle = Theme.of(context).textTheme.title;

    // Prefilled values for text controllers
    titleController.text = note.title;

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(icon: Icon(
            Icons.arrow_back),
            onPressed: (){
              moveToLastScreen();
            }),
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
                decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
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
                      setState(() {
                        debugPrint("Save Button Pressed");
                        _save(noteProvider);
                      });
                    },
                  ),
                ),

              ]),
            )
          ]),
        ),
      ),
    );
  }


  // Save data to the database
  void _save(NoteProvider noteProvider) async {
    Navigator.pop(context, true);
    
    note.title = titleController.text;
    note.description = titleController.text;
    note.date = DateFormat.yMMMd().format(DateTime.now());
    
    int result;
    
    if (note.id != null) {
      // Case 1 : Update Operation
      result = await noteProvider.updateNote(note);
    } else {
      // Case 2 : Insert Operation
      result = await noteProvider.insertNote(note);
    }
    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Note saved successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'There was some problem saving the note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _delete(NoteProvider noteProvider) async {
    Navigator.pop(context, true);
    // Case 1 : If a user is trying to delete the NEW Note i.e. (s)he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }
    // Case 2 : User is trying to delete the old note that has a VALID ID.
    int result = await noteProvider.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted successfully');
    } else {
      _showAlertDialog('Status', 'Error occurred in deleting the note');
    }
  }

  void moveToLastScreen(){
    Navigator.pop(context, true);
  }
}
