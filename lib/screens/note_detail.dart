import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pass_list/models/note.dart';
import 'package:pass_list/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  NoteDetailState createState() => NoteDetailState(this.note, this.appBarTitle);
}

class NoteDetailState extends State<NoteDetail> {
  static var _priorities = ["High", "Low"];

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    // Prefilled values for text controllers
    titleController.text = note.title;
    descriptionController.text = note.description;

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
            // First element
            ListTile(
              title: DropdownButton(
                items: _priorities.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    child: Text(dropDownStringItem),
                    value: dropDownStringItem,
                  );
                }).toList(),
                style: textStyle,
                value: getPriorityAsString(note.priority),
                onChanged: (valueSelectedByUser) {
                  setState(() {
                    debugPrint("User Selected $valueSelectedByUser");
                    updatePriorityAsInt(valueSelectedByUser);
                  });
                },
              ),
            ),

            // Second Element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                style: textStyle,
                controller: titleController,
                onChanged: (value) {
                  debugPrint("Something changed in title text field to $value");
                  updateTitle();
                },
                decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            // Third Element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                style: textStyle,
                controller: descriptionController,
                onChanged: (value) {
                  debugPrint(
                      "Something changed in Description text field to $value");
                  updateDescription();
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            // Fourth Element
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
                        _save();
                      });
                    },
                  ),
                ),

                SizedBox(
                  width: 5.0,
                ),

                // Delete Button : Second Element
                Expanded(
                  child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      "Delete",
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      setState(() {
                        debugPrint("Delete Button Pressed");
                        _delete();
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

  // Convert the String priority in the form of integer before saving it to database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
      default:
        note.priority = 2;
    }
  }

  // Convert int priority to String priority for displaying it to user
  String getPriorityAsString(int intPriority) {
    String priority;
    switch (intPriority) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }

  // Update the title of the Note Object
  void updateTitle() {
    note.title = titleController.text;
  }

  // Update the description of the Note Object
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // Save data to the database
  void _save() async {
    Navigator.pop(context, true);
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      // Case 1 : Update Operation
      result = await helper.updateNote(note);
    } else {
      // Case 2 : Insert Operation
      result = await helper.insertNote(note);
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

  void _delete() async {
    Navigator.pop(context, true);
    // Case 1 : If a user is trying to delete the NEW Note i.e. (s)he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }
    // Case 2 : User is trying to delete the old note that has a VALID ID.
    int result = await helper.deleteNote(note.id);
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
