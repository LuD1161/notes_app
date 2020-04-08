import 'package:flutter/material.dart';
import 'package:pass_list/screens/note_list.dart';
import 'package:pass_list/utils/NoteProvider.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note List Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home: ChangeNotifierProvider(
      builder: (context) => NoteProvider(),
      child: NoteList(),
    ),
      // home: NoteDetail(),
    );
  }
}