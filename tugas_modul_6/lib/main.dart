import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daftar Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> dataGame = [];

  // Gambar lokal
  final List<String> gambar = [
    'assets/icon/boy.png',
    'assets/icon/timetable.png',
    'assets/icon/clipboard.png',
    'assets/icon/homescholling.png',
    'assets/icon/marks.png',
    'assets/icon/pencil.png',
  ];

  @override
  void initState() {
    super.initState();
    _ambilData();
  }

  Future<void> _ambilData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://www.freetogame.com/api/games',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          dataGame = data.take(20).toList();
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Game',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
        Theme.of(context).colorScheme.inversePrimary,
      ),

      body: dataGame.isEmpty
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: dataGame.length,
        itemBuilder: (context, index) {
          return _listItem(
            gambar[index % gambar.length],
            dataGame[index]['title'] ??
                'Tidak ada judul',
            dataGame[index]['genre'] ??
                'Tidak ada genre',
            dataGame[index]['release_date'] ??
                'Tidak ada tanggal',
          );
        },
      ),
    );
  }
}

// Tombol Baca Info
Container _tombolBaca() {
  return Container(
    padding: const EdgeInsets.symmetric(
      vertical: 5,
      horizontal: 15,
    ),
    decoration: BoxDecoration(
      color: Colors.orange,
      borderRadius: BorderRadius.circular(15),
    ),
    child: const Text(
      'Baca Info',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

// Item daftar
Widget _listItem(
    String url,
    String judul,
    String genre,
    String rilis,
    ) {
  return Container(
    margin: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 6,
    ),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.grey.shade300,
        width: 1,
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // GAMBAR LOKAL
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            url,
            width: 100,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                judul,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                'Genre: $genre',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'Rilis: $rilis',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 7),

              _tombolBaca(),
            ],
          ),
        ),
      ],
    ),
  );
}