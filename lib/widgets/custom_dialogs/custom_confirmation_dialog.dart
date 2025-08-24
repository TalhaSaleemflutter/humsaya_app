import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onConfirm,
}) {
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(content),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context, false),
          child: Text("Cancel"),
        ),
        CupertinoDialogAction(
          onPressed: () {
            onConfirm();
            Navigator.pop(context, true);
          },
          isDestructiveAction: true, // Red color for the delete button
          child: Text("OK"),
        ),
      ],
    ),
  );
}
