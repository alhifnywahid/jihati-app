import 'package:flutter/material.dart';

class AlquranScreen extends StatelessWidget {
  const AlquranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AlquranScreen')),
      body: Center(child: Center(child: Text("Alquran"))),
    );
  }
}
