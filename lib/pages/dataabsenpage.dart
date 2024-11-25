import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataAbsen extends StatefulWidget {
  const DataAbsen({Key? key}) : super(key: key);

  @override
  _DataAbsenState createState() => _DataAbsenState();
}

class _DataAbsenState extends State<DataAbsen> {
  Future<List<dynamic>> fetchAbsenData() async {
    final String url = 'http://127.0.0.1:8000/api/absen/index';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load absen data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Absen"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchAbsenData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final absenData = snapshot.data!;
            return ListView.builder(
              itemCount: absenData.length,
              itemBuilder: (context, index) {
                final item = absenData[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${item['status']}'),
                      Text('Waktu Absen: ${item['waktu_absen']}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
