import 'package:eb20242u202114900/UI/favortite_photos_screen.dart';
import 'package:eb20242u202114900/UI/show_photos_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyNasaInsights());
}

class MyNasaInsights extends StatelessWidget {
  const MyNasaInsights({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyNasaInsights',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  String selectApi(String code) {
    int lastDigit = int.parse(code[code.length - 1]);
    return lastDigit % 2 == 0 ? "Mars Rover Photos" : "APOD";
  }

  @override
  Widget build(BuildContext context) {
    String code = "U202114900";
    String selectedApi = selectApi(code);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyNasaInsights',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 110.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Welcome to NASA',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              Image.asset('assets/icons/main_icon.jpeg', height: 200, width: 200, fit: BoxFit.cover),
              const SizedBox(height: 16),
              const Text(
                'Nombre del Alumno: Sharon Barrial',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                'Código de Alumno: U202114900',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'API Key: $selectedApi',
                  style: TextStyle(fontSize: 18, color: Colors.purple),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16, width: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShowPhotosScreen()),
                      );
                    },
                    child: const Text('Mostrar'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FavoritesScreen()),
                      );
                    },
                    child: const Text('Favoritos'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}