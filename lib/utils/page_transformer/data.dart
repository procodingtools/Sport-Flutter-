import 'package:flutter/material.dart';

class IntroItem {
  IntroItem({
    this.title,
    this.category,
    this.imageUrl,
    this.page,
  });

  final String title;
  final String category;
  final String imageUrl;
  final Widget page;
}