import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AbsenPage extends StatefulWidget {
  final int userId;

  const AbsenPage({Key? key, required this.userId}) : super(key: key);

  @override
  _AbsenPageState createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  Future<void> absenUser(BuildContext context) async {
    final String url = 'http://127.0.0.1:8000/api/absen/${widget.userId}';

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Absen Success')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(responseData['message'] ?? 'Absen failed to update')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Absen Page"),
        backgroundColor: Color(0xFF004D40),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF4F5F8),
              Color(0xFF004D40),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => absenUser(context),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 70),
                  backgroundColor: Color(0xFF004D40),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Absen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Teks di bawah navbar
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: _animation,
                        size: 30, // Ukuran ikon animasi lambaian tangan
                        color: Color(0xFF004D40),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Halo Rofiq, Selamat Pagi',
                        style: TextStyle(
                          fontSize: 23, // Ukuran font sedang
                          color: Color(0xFF004D40),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Silahkan absen untuk hari ini',
                    style: TextStyle(
                      fontSize: 18, // Ukuran font sangat kecil
                      color: Color(0xFF004D40),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF004D40),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 1, // Menjadikan "Absen Sekarang" aktif
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage),
            label: 'Data Absen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Absen Sekarang',
          ),
        ],
      ),
    );
  }
}
