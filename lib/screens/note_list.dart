import 'package:flutter/material.dart';
import 'package:pass_list/models/note.dart';
import 'package:pass_list/screens/note_detail.dart';
import 'package:pass_list/utils/NoteProvider.dart';
import 'package:provider/provider.dart';

class NoteList extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note List"),
      ),
      body: getnoteListView(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChangeNotifierProvider(
              builder: (context) => NoteProvider(),
              child: NoteDetail(Note('', '', 2), 'Add Note'),
            );
          }));
        },
        tooltip: "Add Note",
        child: Icon(Icons.add),
      ),
    );
  }

  getnoteListView(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    var noteList = noteProvider.noteList;
    var count = noteList.length;
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return RefreshIndicator(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: count>0
            ? ListView.builder(
                itemCount: count,
                itemBuilder: (BuildContext context, int index) {
                  print(noteList[index].title);
                  return Text(
                    noteList[index].title,
                    style: titleStyle,
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
      onRefresh: () => null,
    );
  }
}
