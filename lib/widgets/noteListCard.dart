import 'package:flutter/material.dart';
import 'package:pass_list/models/note.dart';
import 'package:pass_list/utils/noteHelper.dart';

class NoteListCard extends StatelessWidget {
  final Note item;

  NoteListCard({@required this.item});
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 2.0,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: getPriorityColor(item.priority),
            child: getPriorityIcon(item.priority),
          ),
          title: Text(
            item.title,
            style:Theme.of(context).textTheme.subhead,
          ),
          subtitle: Text(item.date),
          onTap: () {
            showNewDialog(context, item);
          },
        ),
      );
  }
}