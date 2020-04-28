import 'package:flutter/material.dart';
import 'package:pass_list/models/note.dart';
import 'package:pass_list/screens/createNote.dart';
import 'package:pass_list/utils/notesProvider.dart';
import 'package:provider/provider.dart';
// import 'package:pass_list/screens/note_detail.dart';

class NoteList extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note List"),
      ),
      body: _NoteListContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return CreateNote();
              },
            ),
          );
        },

        // onPressed: ()=>notesProvider.insertNote(Note('asdasd','', 2)),
        tooltip: "Add Note",
        child: Icon(Icons.add),
      ),
    );
  }
}

class _NoteListContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NotesProvider noteProvider = Provider.of<NotesProvider>(context);

    if (noteProvider == null) return Container(); //Pi: if it is empty dont do anything.. it happens in a fraction of a section and you wont notice this anyways
    if (noteProvider.list == null) return Container();

    List<Note> noteList = noteProvider.list;

    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: noteList.length,
      itemBuilder: (BuildContext context, int index) {
        return _NoteListItem(noteList[index], index);
      },
    );
  }
}

// Pi: Seperated components out to make it easier to follow.
class _NoteListItem extends StatelessWidget {
  final Note note;
  final int index;
  _NoteListItem(this.note, this.index);
  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    var primaryColor = Theme.of(context).primaryColor;
    return Dismissible(
      confirmDismiss: (a) => Provider.of<NotesProvider>(context, listen: false).deleteNote(note.id),
      background: Container(
        color: Colors.red,
      ),
      key: UniqueKey(),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: primaryColor.withAlpha(25),
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: primaryColor,
            ),
          ),
        ),
        title: Text(
          note.title,
          style: titleStyle,
        ),
      ),
    );
  }
}
