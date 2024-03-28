import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../env.sample.dart';
import '../models/student.dart';
import './edit.dart';

class Details extends StatefulWidget {
  final Student? student;

  Details({this.student});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  void deleteStudent(context) async {
    if (widget.student != null) {
      await http.post(
        Uri.parse("${Env.URL_PREFIX}/delete.php"),
        body: {
          'id': widget.student!.id.toString(),
        },
      );
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    }
  }

  void confirmDelete(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Are you sure you want to delete this?'),
          actions: <Widget>[
            ElevatedButton(
              child: Icon(Icons.cancel),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Icon(Icons.check_circle),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, foregroundColor: Colors.white),
              // textColor: Colors.white,
              onPressed: () => deleteStudent(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.delete),
          //   onPressed: () => confirmDelete(context),
          // ),
        ],
      ),
      body: Container(
        height: 270.0,
        padding: const EdgeInsets.all(35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Name : ${widget.student!.name}",
              style: TextStyle(fontSize: 20),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Text(
              "Age : ${widget.student!.age}",
              style: TextStyle(fontSize: 20),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => confirmDelete(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => Edit(student: widget.student!),
          ),
        ),
      ),
    );
  }
}
