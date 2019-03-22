import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'TES UPLOAD EXCEL'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
String text="";
String id;
final db = Firestore.instance;

void createData(List excel) async {
    DocumentReference ref = await db.collection('EXCEL').add({'id':'${excel[0]}', 'nama':'${excel[1]}', 'kota':'${excel[2]}'});
    setState(() => id = ref.documentID);
    print(ref.documentID);
}

  void _openfile()async {
    final path = await FlutterDocumentPicker.openDocument();
    var bytes = new File(path).readAsBytesSync();
    var decoder = new SpreadsheetDecoder.decodeBytes(bytes, update: true);
    for (var table in decoder.tables.keys) {
      print(table);
      print(decoder.tables[table].maxCols);
      print(decoder.tables[table].maxRows);
      print(decoder.tables[table].rows);
      setState(() {
        text=decoder.tables[table].rows.toString();
      });
      for (var row in decoder.tables[table].rows) {
        row[0]=="id"?print("")
            : createData(row);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Text(
            '$text',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openfile,
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
