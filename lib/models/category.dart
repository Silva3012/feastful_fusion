import 'package:flutter/material.dart';

// Define a blueprint of the Category.
class Category {
  const Category(
      {required this.id, required this.title, this.color = Colors.orange});

  final String id;
  final String title;
  final Color color;
}
