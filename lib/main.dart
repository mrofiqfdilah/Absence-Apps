import 'package:flutter/material.dart';
import 'package:spotify_frontend/pages/registerpage.dart';
import 'package:spotify_frontend/pages/loginpage.dart';
import 'package:spotify_frontend/pages/absenpage.dart';
import 'package:spotify_frontend/pages/dataabsenpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absen Apps',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(), // Halaman awal aplikasi
        '/login': (context) => LoginPage(), // Rute login diperbaiki dengan '/'
        '/dataabsen': (context) => DataAbsen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/absen') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => AbsenPage(userId: args['id']),
          );
        }
        return null;
      },
    );
  }
}
