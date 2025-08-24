import 'package:flutter/material.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';

class CustomBottomSheet {
  static void show(
    BuildContext context, {
    required List<BottomSheetItem> items,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                items.map((item) {
                  return ListTile(
                    leading: Icon(
                      item.icon,
                      color:
                          item.iconColor ??
                          ThemeHelper.getTabbarTextColor(context, false),
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        color:
                            item.textColor ??
                            ThemeHelper.getTabbarTextColor(context, false),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context); // Close bottom sheet
                      item.onTap(); // Execute the function
                    },
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}

// Helper class to define each item in the bottom sheet
class BottomSheetItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  BottomSheetItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });
}
