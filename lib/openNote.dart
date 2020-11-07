import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:notes_ui/updateNote.dart';

class OpenNotes extends StatefulWidget {
  final String id;
  OpenNotes({Key key, this.id}) : super(key: key);
  @override
  _OpenNotesState createState() => _OpenNotesState(id);
}

class _OpenNotesState extends State<OpenNotes> {
  String id;
  _OpenNotesState(this.id);

  String _titleCtrl;
  String _descCtrl;

  Future<void> getData() async {
    var url = "https://sr-notesapi-7nov.herokuapp.com/notes/get/" + id;

    var response = await http.get(url);
    var res;
    if (response.statusCode == 200) {
      res = convert.jsonDecode(response.body.toString());
    }
    setState(() {
      _titleCtrl = res['title'];
      _descCtrl = res['desc'];
    });

    return res;
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(
              top: 30,
              left: 30,
              right: 30,
            ),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: _titleCtrl,
                  ),
                  enabled: false,
                  readOnly: true,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: _descCtrl,
                  ),
                  readOnly: true,
                  enabled: false,
                  maxLines: 20,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => UpdateNotes(id: id)));
            },
            label: Text("Update"),
          )),
    );
  }
}
