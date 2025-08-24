import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class FullImageView extends StatefulWidget {
  final File imageFile; // Change from String to File

  const FullImageView({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<FullImageView> createState() => _FullImageViewState();
}

class _FullImageViewState extends State<FullImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: PinchZoom(
          // Optional: adjust maxScale if needed
          maxScale: 3.0,
          onZoomStart: () {
            debugPrint('Start zooming');
          },
          onZoomEnd: () {
            debugPrint('Stop zooming');
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.file(
              widget.imageFile,
              fit: BoxFit.contain, // Use contain to maintain aspect ratio
            ),
          ),
        ),
      ),
    );
  }
}
