import 'dart:io';

import 'package:flutter/material.dart';

class Openfolder extends StatefulWidget {
  const Openfolder({super.key});

  @override
  State<Openfolder> createState() => _OpenfolderState();
}

class _OpenfolderState extends State<Openfolder> {
  late final List<File> _images;

  void imageFromFiles() {
    final imgdirectory = Directory('/storage/emulated/0/Pictures');
    final files = imgdirectory.listSync();
    final images = files.map((files) {
      return File(files.path);
    }).toList();

    setState(() {
      _images = images;
    });
  }

  @override
  void initState() {
    imageFromFiles();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pictures '),
      ),
      body: GridView.builder(
          itemCount: _images.length - 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemBuilder: (context, index) {
            return GridTile(child: Image.file(File(_images[index + 1 ].path)));
          }),
    );
  }
}
