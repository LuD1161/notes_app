import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pass_list/models/note.dart';
import 'package:pass_list/providers/NotesProvider.dart';
import 'package:provider/provider.dart';

import 'noteListCard.dart';

class SlidableNoteListCard extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Note item;
  final Axis direction;
  final Key key;
  final Function navigateToDetail;

  SlidableNoteListCard(
      {@required this.scaffoldKey,
      @required this.item,
      @required this.direction,
      @required this.key,
      @required this.navigateToDetail});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: key,
      direction: direction,
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        IconSlideAction(
            caption: 'Delete',
            color: Colors.grey,
            icon: Icon(
              Icons.delete,
              color: Colors.grey,
            ).icon,
            onTap: () {
              Provider.of<NotesProvider>(context, listen: false).deleteNote(context, item);
              // delete(context, item);
            }),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
            caption: 'Edit',
            color: Colors.grey,
            icon: Icon(
              MdiIcons.pencil,
            ).icon,
            onTap: () => navigateToDetail(context, item, 'Edit Note'))
      ],
      child: NoteListCard(item: item),
    );
  }
}
