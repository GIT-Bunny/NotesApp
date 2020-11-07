import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class UpdateNotes extends StatefulWidget {
  final String id;
  UpdateNotes({Key key, this.id}) : super(key: key);

  @override
  _UpdateNotesState createState() => _UpdateNotesState(id);
}

class _UpdateNotesState extends State<UpdateNotes> {
  String id;
  _UpdateNotesState(this.id);
  TextEditingController _titleCtrl = TextEditingController();
  TextEditingController _descCtrl = TextEditingController();

  Future<void> getData(String id) async {
    var url = "https://sr-notesapi-7nov.herokuapp.com/notes/get/" + id;

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var res = convert.jsonDecode(response.body);
      _titleCtrl.text = res['title'];
      _descCtrl.text = res['desc'];
    }
  }

  Future<void> updateData(String id) async {
    var url = "https://sr-notesapi-7nov.herokuapp.com/notes/update/" + id;

    var response = await http.patch(
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(id);
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
                  hintText: _titleCtrl.text,
                ),
                controller: _titleCtrl,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: _descCtrl.text,
                ),
                maxLines: 20,
                // initialValue: _descCtrl.text,
                controller: _descCtrl,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              updateData(id);
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
