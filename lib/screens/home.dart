import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../env.sample.dart';
import '../models/student.dart';
import './details.dart';
import './create.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  Future<List<Student>> students = Future.value([]);
  final studentListKey = GlobalKey<HomeState>();

  @override
  void initState() {
    super.initState();
    students = getStudentList();
  }

Future<List<Student>> getStudentList() async {
  try {
    final response = await http.get(Uri.parse("${Env.URL_PREFIX}/list.php"));
    if (response.statusCode == 200) {
      // Parse JSON response
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      return items.map<Student>((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data. Kode status: ${response.statusCode}');
    }
  } catch (error) {
    print('Kesalahan saat mengambil data: $error');
    // Tangani kesalahan (misalnya, tampilkan pesan kesalahan kepada pengguna)
    return []; // Atau throw exception tertentu
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: studentListKey,
      appBar: AppBar(
        title: Text('Student List'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: FutureBuilder<List<Student>>(
          future: students,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // By default, show a loading spinner.
            if (!snapshot.hasData) return CircularProgressIndicator();
            // Render student lists
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    trailing: Icon(Icons.view_list),
                    title: Text(
                      data.name,
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Details(student: data)),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return Create();
          }));
        },
      ),
    );
  }
}