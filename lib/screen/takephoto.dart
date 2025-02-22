import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jigsaw/screen/game.dart';

class TakePhotoPage extends StatefulWidget {
  const TakePhotoPage({super.key});

  @override
  State<TakePhotoPage> createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  double? width;
  double? height;
  File? imageFile;

  Future<dynamic> takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.values[0]);

    if (pickedFile != null) {
      imageFile = null;
      setState(() {
        imageFile = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Jigsaw Puzzle Game',
              style: TextStyle(fontSize: 80),
            ),
            Image.asset('assets/images/Jigsaw.png'),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => const AlertDialog(
                    backgroundColor: Colors.transparent,
                    title: SizedBox(
                      height: 200,
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
                takePicture().then((value) {
                  setState(() {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PuzzleWidget(image: imageFile!,grid: 3),
                      ),
                    );
                  });
                });
              },
              child: Container(
                width: width! * .4,
                height: height! * .4,
                decoration: BoxDecoration(
                    color: Colors.pink[200],
                    border: Border.all(
                      width: 3,
                      color: Colors.red,
                    ),
                    shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Text(
                  ' Take \nPhoto',
                  style: TextStyle(fontSize: 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
