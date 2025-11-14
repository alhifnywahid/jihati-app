import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/aboutme_controller.dart';

class AboutmeView extends GetView<AboutmeController> {
  const AboutmeView({super.key});
  @override
  Widget build(BuildContext context) {
    final widgets = List.generate(controller.texts.length * 2 - 1, (i) {
      if (i.isEven) {
        final index = i ~/ 2;
        return Text(
          controller.texts[index],
          textAlign: TextAlign.justify,
          style: const TextStyle(fontSize: 16, height: 1.6),
        );
      } else {
        return const SizedBox(height: 16);
      }
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Kami')),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'PW FORMASI RUA Surabaya',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widgets,
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  '"Bersama kita mengaji, menjalani, dan mengabdi."',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
