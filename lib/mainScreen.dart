import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:notes_ui/newNotes.dart';
import 'package:notes_ui/openNote.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<void> getData() async {
    var url = "https://sr-notesapi-7nov.herokuapp.com/";

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var res = convert.jsonDecode(response.body);
      return res;
    }
  }

  Future<void> deleteData(String id) async {
    var url = "https://sr-notesapi-7nov.herokuapp.com/notes/" + id;

    var response = await http.delete(url);
    if (response.statusCode == 200) {
      print('done');
    }
  }

  Future<void> refreshData() async {
    await Future.delayed(
      Duration(seconds: 1),
    );
    setState(() {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Notes',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.amber[400],
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        backgroundColor: Colors.black87,
        strokeWidth: 3,
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.hasError)
              return Center(
                child: Text('Oops Error Occured'),
              );
            else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      tileColor: Colors.amber[50],
                      title: Text(snapshot.data[index]['title']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OpenNotes(
                              id: snapshot.data[index]['_id'],
                            ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        onPressed: () {
                          deleteData(snapshot.data[index]['_id']);
                          setState(() {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${snapshot.data[index]['title']} deleted',
                                ),
                              ),
                            );
                          });
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ),
                  );
                },
              );
            }
          },
          future: getData(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.amber[400],
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return NewNotes();
              },
            ),
          );
        },
        label: Text(
          'Create',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        icon: Icon(
          Icons.edit_outlined,
          color: Colors.black87,
        ),
      ),
    );
  }
}
