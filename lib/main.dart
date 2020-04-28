import 'package:flutter/material.dart';
import 'package:pass_list/screens/noteList.dart';
import 'package:pass_list/utils/notesProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<NotesProvider>(builder: (_) => NotesProvider()), //Pi: update your provider package... it's old.
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note List Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: NoteList(),
    );
  }
}
