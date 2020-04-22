import 'package:flutter/material.dart';
import 'package:pass_list/providers/NotesProvider.dart';
import 'package:pass_list/screens/outer_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotesProvider>(
          create: (_) => NotesProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Note List Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: OuterPage(),
        // home: NoteDetail(),
      ),
    );
  }
}
