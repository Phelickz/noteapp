import 'package:flutter/material.dart';
import 'package:noteapp/database/database.dart';
import 'package:noteapp/database/db.dart';
import 'package:noteapp/database/dbb.dart';
import 'package:noteapp/models/global.dart';
import 'package:noteapp/models/note.dart';
import 'package:noteapp/service.dart';
import 'package:noteapp/state/notestate.dart';
import 'package:provider/provider.dart';
import 'notepage.dart';


// enum NoteMode{
//   Editing,
//   Adding
// }


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Note> items = new List();
  NotesDatabase db = NotesDatabase.db;

  // @override
  // void initState(){
  //   super.initState();
  //   db.getAllClients().then((notes){
  //     setState((){
  //       notes.forEach((note){
  //         items.add(Note.fromMap(notes);
  //       });
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
      //  extendBodyBehindAppBar: true,
        backgroundColor: darkGreyColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
            child: AppBar(
            backgroundColor: Colors.transparent,
            title: Container(
              padding: EdgeInsets.only(top: 3),
              margin: EdgeInsets.only(top: 30),
              child: Text('Notes', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: redColor),)),
            elevation: 0,
            actions: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 25),
                child: IconButton(icon: Icon(Icons.search), onPressed: (){
                  showSearch(context: context, delegate: DataSearch(this.items));
                }, color: redColor,))
            ],
          ),
        ),
      
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: darkGreyColor,
          splashColor: Colors.white,
          label: Text('New', style: TextStyle(color: redColor, fontWeight: FontWeight.bold)),
          onPressed: (){
            Navigator.push(context, 
            MaterialPageRoute(builder: (context) => NotePage(NoteMode.Adding, null)));
          },
          icon: Icon(Icons.note_add, color: redColor,),
        ),
        body: NoteList(),
      ),
    );
  }
}



class NoteList extends StatefulWidget {
  // final NoteMode noteMode;

  // NoteList(this.noteMode);
  
  

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

  // @override
  // void initState(){
  // super.initState();
  //   } 
  @override
  Widget build(BuildContext context) {
    final notestate = Provider.of<NoteState>(context);
   // List<Map<String , String>> get _notes => Provider.of<NoteState>(context).activeNote.notes;
    return FutureBuilder(
        future: NotesDatabase.db.getAllClients(),
        builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                Note item = snapshot.data[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotePage(NoteMode.Editing, item))
                    );
                  },
                  
                  child: Card(
                    color: redColor,
                    margin: EdgeInsets.only( right: 12, left: 12, bottom: 12, top: 3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 30, left: 13.0, right: 22.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[ Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _NoteTitle(item.title),
                            Container(height: 4,),
                            _Notetext(item.content)
                          ],
                        ),
                        IconButton(icon: Icon(Icons.delete), onPressed: (){
                NotesDatabase.db.deleteNote(item.id);
                //reload page
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) => Home()), (Route<dynamic> route)=>false);
              },)]
                      ),
                    ),
                  ),
                );
              },
              itemCount: snapshot.data.length,
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      );
        
  
  }

  //   void retrieveAllNotesFromDatabase() {
  // // queries for all the notes from the database ordered by latest edited note. excludes archived notes.
  //   var _testData = db.getNoteList();
  //   _testData.then((value){
  //       setState(() {
  //         this._notes = value;
  //         print(_notes);
  //       });
  //   });
  // }
}


class _NoteTitle extends StatelessWidget {
  final String _title;


  _NoteTitle(this._title);
  @override
  Widget build(BuildContext context) {
    return Text(
      _title,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold
      ),
    );
  }
}

class _Notetext extends StatelessWidget {
  final String _content;
  _Notetext(this._content);
  @override
  Widget build(BuildContext context) {
    return Text(
      _content,
      style: TextStyle(
        color: Colors.black
      ),
      maxLines: 300,
      overflow: TextOverflow.ellipsis,
      
    );
  }
}

class DataSearch extends SearchDelegate<Note>{
  NotesDatabase db = NotesDatabase.db;
  List<Note> items = new List();
  List<Note> suggestion = new List();
  DataSearch(this.items);

  @override 
  ThemeData appBarTheme(BuildContext context){
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert (theme!=null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context){
    return [
      IconButton(icon: Icon(Icons.clear), color: redColor, onPressed: (){query ='';},)
    ];
  }

  @override 
  Widget buildLeading(BuildContext context){
    return IconButton(
      color: redColor,
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context){

  }

  @override
  Widget buildSuggestions(BuildContext context){
    final suggestion = query.isEmpty ? items :
    items.where((target)=> target.title.startsWith(query)).toList();
    if(items.isEmpty)
    {
      print('Null');
    }
    return ListView.builder(
      itemBuilder: (context, position) =>
      ListTile(
        title: Text(suggestion[position].title),
      ),
      itemCount: suggestion.length,
    );
  }
}