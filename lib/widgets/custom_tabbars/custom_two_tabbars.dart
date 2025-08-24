import 'package:flutter/material.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';

class CustomTwoTabbar extends StatelessWidget implements PreferredSizeWidget {
  final String firstTabTitle;
  final String secondTabTitle;
  final TextStyle? textStyle;
  final TabController? tabController;

  const CustomTwoTabbar({
    super.key,
    required this.firstTabTitle,
    required this.secondTabTitle,
    this.textStyle,
    this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Make sure no background color is applied
      child: TabBar(
        controller: tabController,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: 6, color: Colors.green),
          borderRadius: BorderRadius.circular(12),
          insets: EdgeInsets.symmetric(
            horizontal: 10,
          ), // Set insets to zero for equal width
        ),
        indicatorSize:
            TabBarIndicatorSize.tab, // Ensure equal width for all tabs
        indicatorColor: Colors.transparent, // Remove default indicator color
        dividerColor: Colors.transparent, // Removes the static bottom line
        labelColor: ThemeHelper.getTabbarTextColor(
          context,
          false,
        ), // Selected tab text color
        unselectedLabelColor: ThemeHelper.getTabbarTextColor(
          context,
          false,
        ), // Unselected tab text color
        labelStyle: textStyle ?? const TextStyle(fontWeight: FontWeight.bold),
        tabs: [Tab(text: firstTabTitle), Tab(text: secondTabTitle)],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
