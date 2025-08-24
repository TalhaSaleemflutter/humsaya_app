import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImagePickerDialog extends StatefulWidget {
  final Uint8List imagePath;

  const ImagePickerDialog({
    super.key,
    required this.imagePath,
  });

  @override
  State<ImagePickerDialog> createState() => _ImagePickerDialogState();
}

class _ImagePickerDialogState extends State<ImagePickerDialog> {
  bool _isLoading = false; // State to track loading

  // void setImage() async {
  //   setState(() {
  //     _isLoading = true; // Show loader
  //   });

  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   try {
  //     await authProvider.updateAndSaveUserImage(
  //         context: context, imageBytes: widget.imagePath);
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //   }

  //   if (mounted) {
  //     Navigator.of(context).pop(); // Close dialog after task completes
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text(
        'Image Preview',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        children: [
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            height: 300.h, // Adjust height as needed
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.memory(
              widget.imagePath,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 15.h),
          const Text(
            'Would you like to set this image as your profile picture?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          SizedBox(height: 15.h),
          Divider(height: 1, color: Colors.grey.shade300), // Divider
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          isDestructiveAction: true,
          child: const Text('Cancel'),
        ),
        CupertinoDialogAction(
          onPressed:
          (){}, // Disable button while loading
          child: _isLoading
              ? const CupertinoActivityIndicator() // Loader when clicked
              : const Text('OK'),
        ),
      ],
    );
  }
}
