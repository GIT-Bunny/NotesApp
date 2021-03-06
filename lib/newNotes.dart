import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class NewNotes extends StatefulWidget {
  @override
  _NewNotesState createState() => _NewNotesState();
}

class _NewNotesState extends State<NewNotes> {
  TextEditingController _titleCtrl = TextEditingController();
  TextEditingController _descCtrl = TextEditingController();

  Future<void> setData() async {
    var url = "https://sr-notesapi-7nov.herokuapp.com/notes/post";

    var response = await http.post(
      url,
      body: convert
          .jsonEncode({"title": _titleCtrl.text, "desc": _descCtrl.text}),
      headers: {"content-type": "application/json"},
    );

    if (response.body == 'OK') {
      Navigator.of(context).pop();
    }
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
                  hintText: 'Title',
                ),
                controller: _titleCtrl,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Description',
                ),
                maxLines: 20,
                controller: _descCtrl,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              setData();
            });
          },
          label: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              right: 40,
              left: 40,
            ),
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
          backgroundColor: Colors.amber[400],
        ),
      ),
    );
  }
}
