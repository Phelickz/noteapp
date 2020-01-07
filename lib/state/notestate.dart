


import 'package:flutter/cupertino.dart';
import 'package:noteapp/models/note.dart';
import 'package:noteapp/service.dart';

class NoteState with ChangeNotifier{
  // List <Note> _noteList = List<Note>();
  Note _activeNote;
  
  final _noteList = [
   {
     'title': 'note1',
     'content': 'i learnt Python'
   },
   {
     'title': 'Note 2',
     'content': 'I learnt Dart'
   },
   {
     'title': 'Note 3',
     'content': 'I am learning Flutter'
   },
   {
     'title': 'Note 4',
     'content': 'I got this motherfucking Provider to work'
   },
   {
     'title': 'note1',
     'content': 'i learnt Python'
   },
   {
     'title': 'Note 2',
     'content': 'I learnt Dart'
   },
   {
     'title': 'Note 3',
     'content': 'I am learning Flutter'
   },
   {
     'title': 'Note 4',
     'content': 'I got this motherfucking Provider to work'
   },

  ];

  //  loadNoteList() {
  //   _noteList = getNoteList();
  //   notifyListeners();
  //   return _noteList;
  // }

  void clearState(){
    _activeNote = null;

  }

  List<Map<String, String>> get noteList => _noteList;
  Note get activeNote => _activeNote;

  set activeNote(newValue){
    _activeNote = newValue;
    notifyListeners();
  }

  // set noteList(List newValue){
  //   _noteList = newValue;
  //   notifyListeners();
  // }


}