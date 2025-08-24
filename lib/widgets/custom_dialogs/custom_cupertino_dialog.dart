import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void cupertinoDialog(BuildContext context, String message) {
  
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Alert'),
        content: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Text(
            message,
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

Future<void> showCustomConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirm,
}) async {
  return showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: Container(
          width: 300.w, // Adjust dialog width
          padding: EdgeInsets.all(16.w), // Add padding around the dialog
          child: CupertinoAlertDialog(
            title: Text(title),
            content: Padding(
              padding: EdgeInsets.only(
                  top: 10.h), // Add space between title and content
              child: Text(
                message,
                style: TextStyle(fontSize: 16.sp), // Increase text size
              ),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm(); // Call the confirm function
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
