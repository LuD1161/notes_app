import 'package:flutter/material.dart';
import 'package:pass_list/providers/NotesProvider.dart';
import 'package:pass_list/widgets/noteCard.dart';
import 'package:provider/provider.dart';

enum viewType { List, Staggered }

class NotePage extends StatefulWidget {
  static const routeName = '/NotePage';
  final notesViewType;
  const NotePage({Key key, this.notesViewType}) : super(key: key);
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  viewType notesViewType;

  @override
  void initState() {
    super.initState();
    this.notesViewType = widget.notesViewType;
  }

  @override
  Widget build(BuildContext context) {
    final Axis slidableDirection = Axis.horizontal;
    return Container(
        child: Consumer<NotesProvider>(
            builder: (context, notes, _) => notes.decryptedNoteList.isNotEmpty
                ? ListView.builder(
                    itemCount: notes.allNotes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SlidableNoteListCard(
                        direction: slidableDirection,
                        item: notes.allNotes[index],
                        key: Key(notes.allNotes[index].id.toString()),
                        navigateToDetail: null,
                        scaffoldKey: null,
                      );
                    },
                  )
                : CircularProgressIndicator()));
  }

}
