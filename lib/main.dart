import 'package:flutter/material.dart';
import 'package:noteapp/state/notestate.dart';
//import 'package:noteapp/models/note.dart';
//import 'package:noteapp/state/notestate.dart';
import 'package:noteapp/views/homepage.dart';
import 'package:provider/provider.dart';

void main() => runApp(Notekeep());

class Notekeep extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NoteState(),
        )
      ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(

            primarySwatch: Colors.blue,
          ),
          home: Home(),
        ),
    );
  }
}
