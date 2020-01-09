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
import 'package:flutter_swiper/flutter_swiper.dart';


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
//for the search bar functionality
  @override
  void initState(){
    super.initState();
    db.getAllClients().then((notes){
      setState((){
        notes.forEach((note){
          items.add(Note.fromMap(note.toMap()));
        });
      });
    });
  }

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
            return Container(
              height: 400,
              margin: EdgeInsets.only(top: 60),
              child: Swiper(
                layout: SwiperLayout.STACK,
                itemWidth: 370,
                itemBuilder: (BuildContext context, int index) {
                  Note item = snapshot.data[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NotePage(NoteMode.Editing, item))
                      );
                    },
                    
                    child: Container(
                      height: 300,
                      child: Card(
                        
                        color: redColor,
                        margin: EdgeInsets.only( right: 12, left: 12, bottom: 12, top: 3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30.0, bottom: 30, left: 13.0, right: 22.0),
                          child: new SingleChildScrollView(
                                                  child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[ new Flexible(
                                                          child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: _NoteTitle(item.title)),
                                    Container(height: 70,),
                                    _Notetext(item.content)
                                  ],
                                ),
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
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data.length,
              ),
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
        fontSize: 35,
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
        fontSize: 17,
        color: Colors.black
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      
    );
  }
}

//class for the search bar functionality

class DataSearch extends SearchDelegate<Note>{
  NotesDatabase db = NotesDatabase.db;
  List<Note> items = new List();
  List<Note> suggestion = new List();
  DataSearch(this.items);

  // @override 
  // ThemeData appBarTheme(BuildContext context){
  //   assert(context != null);
  //   final ThemeData theme = Theme.of(context);
  //   assert (theme!=null);
  //   return theme;
  // }

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
              child: ListTile(
          title: Text(suggestion[index].title),
        ),
      );},
      itemCount: suggestion.length,
    );
  }return Center(child: CircularProgressIndicator());
  }
  );
}
}