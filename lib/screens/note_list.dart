import 'package:flutter/material.dart';
import 'package:pass_list/models/note.dart';
import 'package:pass_list/utils/database_helper.dart';
import 'package:pass_list/utils/noteHelper.dart';
import 'package:pass_list/widgets/noteCard.dart';

class NoteList extends StatefulWidget {
  NoteList();

  @override
  NoteListState createState() => NoteListState();
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: FutureBuilder(
          future: updateListView(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error : " + snapshot.error));
            }
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            var noteList = snapshot.data;
            return getnoteListView(context, noteList);
          }),
    );
  }

  ListView getnoteListView(BuildContext context, dynamic noteList) {
    final Axis slidableDirection = Axis.horizontal;
    return ListView.builder(
      itemCount: noteList.length,
      itemBuilder: (BuildContext context, int index) {
        return SlidableNoteListCard(
          direction: slidableDirection,
          item: noteList[index],
          key: Key(noteList[index].id.toString()),
          navigateToDetail: navigateToDetail,
          scaffoldKey: _scaffoldKey,
        );
      },
    );
  }
}
