import 'package:flutter/material.dart';
import 'package:pass_list/providers/NotesProvider.dart';
import 'package:pass_list/widgets/noteCard.dart';
import 'package:provider/provider.dart';

class NoteListScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  NoteListScreen(this._scaffoldKey);

  @override
  Widget build(BuildContext context) {
    final Axis slidableDirection = Axis.horizontal;
    return Container(
        child: Consumer<NotesProvider>(
            builder: (context, notes, _) => notes.allNotes.isNotEmpty
                ? ListView.builder(
                    itemCount: notes.allNotes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SlidableNoteListCard(
                        direction: slidableDirection,
                        item: notes.allNotes[index],
                        key: Key(notes.allNotes[index].id.toString()),
                        navigateToDetail: null,
                        scaffoldKey: _scaffoldKey,
                      );
                    },
                  )
                : CircularProgressIndicator()));
  }
}
