import 'dart:io';

import 'package:flutter/material.dart';

class Imageview extends StatefulWidget {
  final String imagePath;

  const Imageview({super.key, required this.imagePath});

  @override
  State<Imageview> createState() => _ImageviewState();
}

class _ImageviewState extends State<Imageview> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('${DateTime.now()}'),
      ),
      body: Center(
        child: Image.file(
          File(widget.imagePath),
        ),
      ),
    );
  }
}
