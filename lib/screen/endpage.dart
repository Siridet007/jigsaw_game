import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class EndPage extends StatefulWidget {
  final File image;
  final String time;
  const EndPage({super.key, required this.image, required this.time});

  @override
  State<EndPage> createState() => _EndPageState();
}

class _EndPageState extends State<EndPage> {
  double? width;
  double? height;
  File? image;
  @override
  void initState() {
    super.initState();
    image = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: image == null
          ? LoadingAnimationWidget.beat(color: Colors.pink, size: 60)
          : Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(image!),
                  opacity: 0.3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.time,
                        style: const TextStyle(
                          fontSize: 80,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
