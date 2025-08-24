import 'package:flutter/material.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';

class CustomTabBarHumsayaApp extends StatelessWidget
    implements PreferredSizeWidget {
  final List<String> tabTitles;
  final TextStyle? textStyle;
  final TabController? tabController;

  const CustomTabBarHumsayaApp({
    super.key,
    required this.tabTitles,
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
        tabs: tabTitles.map((title) => Tab(text: title)).toList(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
