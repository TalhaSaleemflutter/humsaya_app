import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/views/home/dashboard_screens/adds/ad_status_screen.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_listtile.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_button.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarHeight: 45.h,
        title: 'Filter',
        textStyle: AppTextStyles.appBarHeadingText(context),
        leadingIcon: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppAssets.icBack,
              height: 20.h,
              width: 20.w,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
          ),
        ),
        trailingIcon: SizedBox(),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.h),
            Container(
              decoration: BoxDecoration(
                color: ThemeHelper.getCardColor(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onTap: () {},
                decoration: InputDecoration(
                  hintText: 'Search place or address',
                  prefixIcon: Icon(
                    Icons.search,
                    color: ThemeHelper.getTabbarTextColor(context, false),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text('Ad Status', style: AppTextStyles.subHeadingText(context)),
            SizedBox(height: 8.h),
            CustomListTile(
              path: '',
              iconColor: iconColor,
              title: 'All Ads',
              subtitle: '',
              color: Theme.of(context).scaffoldBackgroundColor,
              isMore: true,
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: iconColor,
                size: 17,
              ),
            ),
            SizedBox(height: 16.h),
            Text('Category', style: AppTextStyles.subHeadingText(context)),
            SizedBox(height: 8.h),
            CustomListTile(
              dataIcon: CupertinoIcons.device_phone_portrait,
              path: '',
              iconColor: white,
              title: 'Mobiles',
              subtitle: '',
              color: blue,
              isMore: true,
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: iconColor,
                size: 17,
              ),
            ),
            SizedBox(height: 400.h),
            CustomButton(
              txtColor: white,
              bgColor: primary,
              text: 'Apply',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdStatusScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
