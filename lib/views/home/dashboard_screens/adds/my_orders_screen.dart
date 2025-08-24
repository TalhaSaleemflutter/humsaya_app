import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/widgets/custom_tabbars/custom_tabbar_hamsaya_app.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    ); // Initialize TabController
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        //backgroundColor: AppColor.lightgreyColor,
        appBarHeight: 45.h,
        title: 'My Orders',
        leadingIcon: Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            AppAssets.icBack,
            height: 20.h,
            width: 20.w,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        textStyle: AppTextStyles.appBarHeadingText(context),
        trailingIcon: Icon(CupertinoIcons.ellipsis_vertical),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 22.w, right: 22.w),
        child: Column(
          children: [
            CustomTabBarHumsayaApp(
              tabTitles: ["Actual", "Scheduled", "Expired"],
              textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              tabController: _tabController, // Pass the TabController
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
