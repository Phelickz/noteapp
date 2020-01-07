import 'package:flutter/material.dart';
import 'package:noteapp/database/database.dart';
import 'package:noteapp/database/dbb.dart';
import 'package:noteapp/models/global.dart';
import 'package:noteapp/models/note.dart';
import 'package:noteapp/state/notestate.dart';
import 'package:noteapp/views/homepage.dart';
import 'package:provider/provider.dart';



enum NoteMode{
  Editing,
  Adding
}


class NotePage extends StatefulWidget {

  final NoteMode noteMode;
  final Note note;

  NotePage(this.noteMode, this.note);

  @override
  _NotePageState createState() => _NotePageState(noteMode);
}

class _NotePageState extends State<NotePage> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final NoteMode noteMode;

  _NotePageState(this.noteMode);
  get notestate => Provider.of<NoteState>(context).noteList;

  // this function is here so that the title and content shows up when you are in editing mode.
  // for some reasons, i couldnt use the initstate because off thte state management errors.
  // this comment is here to remind you why you are the using the change dependencies method
  @override
  void didChangeDependencies(){
    if(widget.noteMode == NoteMode.Editing){
     _titleController.text = widget.note.title;
      _contentController.text = widget.note.content;
      super.didChangeDependencies();
  }}
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteState>(
      builder: (context, notestate, child)=>
        Scaffold(
          backgroundColor: darkGreyColor,
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.home), color: redColor, onPressed: (){Navigator.pop(context);},),
          backgroundColor: darkGreyColor,
          title: Text(noteMode == NoteMode.Adding ? 'Add Note' : 'Edit note', 
            style: TextStyle(color: redColor, fontWeight: FontWeight.bold),),
          actions: <Widget>[
            
              IconButton(icon: Icon(Icons.save), color: redColor, onPressed: () {
                if (widget?.noteMode == NoteMode.Adding){
                  final title = _titleController.text;
                  final content = _contentController.text;
                  NotesDatabase.db.newNote(Note(title : title, content : content));
                }else if (widget?.noteMode == NoteMode.Editing) {
                  NotesDatabase.db.updateNote(Note(
                    id : widget.note.id,
                    title: _titleController.text,
                    content: _contentController.text

                  ),
                  );
              print(' Note updated');
                }
                Navigator.pop(context);
              },),
              noteMode == NoteMode.Editing ? 
              IconButton(icon: Icon(Icons.delete), color: redColor, onPressed: (){
                NotesDatabase.db.deleteNote(widget.note.id);
                Navigator.pop(context);
              },) : Container()
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 5, right: 5, top: 5),
              padding: EdgeInsets.only(left: 4, right: 4),
                child: TextField(    
                controller: _titleController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Title',
                  filled: true,
                  fillColor: Colors.grey.shade200
                )
              ),
            
            ),
            // Divider(
            //   thickness: 0.5,
            // ),
            SizedBox(height: 10,),
            Flexible(
              child: Container(
                margin: EdgeInsets.only(left: 5, right: 5,),
                padding: EdgeInsets.only(left: 4, right: 4),
                child: TextField(
                  controller: _contentController,
                  decoration: InputDecoration.collapsed(hintText: 'Content', filled: true,
                  fillColor: Colors.grey.shade100),
                  maxLines: 1000,
                  
              ),
                        ),
            )
          ],
        ),
      ),
    );
  }
}