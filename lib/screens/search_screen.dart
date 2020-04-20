import 'package:flutter/material.dart';
import 'package:pass_list/models/note.dart';
import 'package:pass_list/utils/database_helper.dart';
import 'package:pass_list/utils/noteHelper.dart';
import 'package:pass_list/widgets/noteCard.dart';
import 'package:pass_list/widgets/noteListCard.dart';
// import 'package:pass_list/widgets/noteListCard.dart';
// import 'package:pass_list/widgets/slidableNoteListCard.dart';

//Search delegate
class SearchAppBarDelegate extends SearchDelegate<Note> {
  final List<Note> _history;
  DatabaseHelper databaseHelper = DatabaseHelper();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Note> noteList;

  SearchAppBarDelegate(List<Note> noteList)
      : noteList = noteList,
        //pre-populated history of words
        // using set to only keep unique elements in history
        _history = <Note>[],
        super();

  // Setting leading icon for the search bar.
  //Clicking on back arrow will take control to main page
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        //Take control back to previous page
        this.close(context, null);
      },
    );
  }

  // Builds page to populate search results.
  @override
  Widget buildResults(BuildContext context) {
    Note note = noteList
        .where(
            (note) => note.title.toLowerCase().startsWith(query.toLowerCase()))
        .first;
    return Scaffold(
        key: _scaffoldKey,
        body: GestureDetector(
          onTap: () {
            _history.add(note);
          },
          child: NoteListCard(
            item: note,
          ),
        ));
  }

  // Suggestions list while typing search query - this.query.
  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<Note> suggestions = this.query.isEmpty
        ? _history
        : noteList.where((note) => note.title.toLowerCase().startsWith(query
            .toLowerCase())); // Convert both to lowercase for all comparision

    return _WordSuggestionList(
      query: this.query,
      noteList: this.noteList,
      suggestions: suggestions.toList(),
      scaffoldKey: _scaffoldKey,
      history: this._history,
      onSelected: (Note suggestion) {
        this.query = suggestion.title;
        this._history.add(suggestion);
        showResults(context);
      },
    );
  }

  // Action buttons at the right of search bar.
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isNotEmpty
          ? IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
          : IconButton(
              icon: const Icon(Icons.mic),
              tooltip: 'Voice input',
              onPressed: () {
                this.query = 'TBW: Get input from voice';
              },
            ),
    ];
  }
}

// Suggestions list widget displayed in the search page.
class _WordSuggestionList extends StatelessWidget {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final List<Note> noteList;

  _WordSuggestionList(
      {this.suggestions,
      this.query,
      this.onSelected,
      this.scaffoldKey,
      this.history,
      this.noteList});

  final List<Note> suggestions;
  final String query;
  final ValueChanged<Note> onSelected;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<Note> history;
  final Axis slidableDirection = Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        Note note = suggestions.elementAt(index);
        return GestureDetector(
            onTap: () {
              history.add(note);
            },
            child: SlidableNoteListCard(
              key: Key(note.id.toString()),
              scaffoldKey: scaffoldKey,
              item: note,
              direction: slidableDirection, navigateToDetail: null,
            ));
      },
    );
  }

  delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      print("history");
      print(history);
      print("Suggestions");
      print(suggestions);
      noteList.remove(note);
      history.remove(note);
      showSnackBar(context, 'Note Deleted again Successfully');
    }
  }
}
