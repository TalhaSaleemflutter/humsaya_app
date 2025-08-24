import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/widgets/custom_tabbars/custom_two_tabbars.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';

class SellingOrders extends StatefulWidget {
  const SellingOrders({super.key});

  @override
  _SellingOrdersState createState() => _SellingOrdersState();
}

class _SellingOrdersState extends State<SellingOrders>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
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
        appBarHeight: 50.h,
        title: 'Buying Orders',
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
            CustomTwoTabbar(
              firstTabTitle: "Active",
              secondTabTitle: "Archived",
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              tabController: _tabController, // Pass the TabController
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
