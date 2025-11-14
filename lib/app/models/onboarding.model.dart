import 'package:flutter/material.dart';

class OnboardingModel {
  final String title;
  final String description;
  final String imageUrl;
  final Color textColor;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.textColor = Colors.black,
  });
}
