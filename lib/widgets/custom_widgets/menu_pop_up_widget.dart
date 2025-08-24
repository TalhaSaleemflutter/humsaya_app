import 'package:flutter/material.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/widgets/custom_widgets/generic_dashboard_widgets.dart';


class CustomPopupMenuButton extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const CustomPopupMenuButton({
    Key? key,
    required this.onEdit,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final offset =
            renderBox.localToGlobal(Offset.zero); // Get position of the widget

        // Show the menu using the correct position
        final result = await showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            offset.dx - 200, // Shift left by 200px
            offset.dy,
            offset.dx - 49, // Maintain balance
            offset.dy + 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          color: ThemeHelper.getBlackWhite(context), // Background color
          elevation: 8, // Soft shadow
          items: [
            const PopupMenuItem(
              value: 'Change Widgets order',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.blue),
                  SizedBox(width: 10),
                  Text('Change Widgets order',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'Remove Widget',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Remove Widget',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        );

        // Handle the result of the menu
        if (result == 'Change Widgets order') {
          onEdit(); // Call the edit callback
        } else if (result == 'Remove Widget') {
          onRemove(); // Call the remove callback
        }
      },
      child: GenericDashboardWidgets.moreIconVertical(context),
    );
  }
}
