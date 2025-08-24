import 'package:flutter/material.dart';

class CustomTabBarHamsayaApp extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabTitles;
  final TextStyle? textStyle;

  const CustomTabBarHamsayaApp({
    Key? key,
    required this.tabTitles,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure that there is a TabController available in the widget tree
    final TabController? tabController = DefaultTabController.of(context);
    if (tabController == null) {
      throw FlutterError(
        "No TabController found. Wrap this widget inside a DefaultTabController.",
      );
    }

    return TabBar(
      controller: tabController, // Explicitly set the controller
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(width: 3.0, color: Colors.green),
        insets: EdgeInsets.symmetric(horizontal: 20),
      ),
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black54,
      labelStyle: textStyle ?? const TextStyle(fontWeight: FontWeight.bold),
      tabs: tabTitles.map((title) => Tab(text: title)).toList(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
