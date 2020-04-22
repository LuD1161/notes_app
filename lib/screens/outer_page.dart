import 'package:flutter/material.dart';
import 'package:pass_list/models/note.dart';
import 'package:pass_list/providers/NotesProvider.dart';
import 'package:pass_list/screens/another_screen.dart';
import 'package:pass_list/screens/note_list.dart';
import 'package:pass_list/screens/search_screen.dart';
import 'package:pass_list/utils/database_helper.dart';
import 'package:pass_list/utils/noteHelper.dart';
import 'package:provider/provider.dart';

class OuterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OuterPageState();
  }
}

class OuterPageState extends State<OuterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedTab = 0;
  var noteList;
  final _pageOptions = [
    NoteList(),
    AnotherScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var noteProvider = Provider.of<NotesProvider>(context);
    // https://stackoverflow.com/a/53839983
    var customFabButton;
    if (_selectedTab == 0) {
      customFabButton = FloatingActionButton(
        // Password section
        onPressed: () {
          navigateToDetail(context, Note('', '', 2), 'Add Note');
        },
        child: Icon(Icons.add),
      );
    } else if (_selectedTab == 1) {
      // Notes Section
      customFabButton = FloatingActionButton(
        onPressed: () => null,
        child: Icon(Icons.add),
      );
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Notes"),
        actions: <Widget>[
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            //Don't block the main thread
            onPressed: () {
              showSearchPage(context, SearchAppBarDelegate(noteProvider));
            },
          ),
        ],
      ),
      body: _pageOptions[_selectedTab],
      floatingActionButton: customFabButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        shape: CircularNotchedRectangle(),
        notchMargin: 4,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          fixedColor: Colors.white70,
          currentIndex: _selectedTab,
          onTap: (int index) {
            setState(() {
              _selectedTab = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              title: Text('Notes'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.error),
              title: Text('Another'),
            ),
          ],
        ),
      ),
    );
  }

  //Shows Search result
  void showSearchPage(
      BuildContext context, SearchAppBarDelegate searchDelegate) async {
    await showSearch<Note>(
      context: context,
      delegate: searchDelegate,
    );
  }
}
