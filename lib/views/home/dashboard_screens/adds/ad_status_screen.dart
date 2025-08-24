import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_listtile.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';

class AdStatusScreen extends StatefulWidget {
  const AdStatusScreen({super.key});
  @override
  State<AdStatusScreen> createState() => _AdStatusScreenState();
}

class _AdStatusScreenState extends State<AdStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarHeight: 45.h,
        title: 'Ad Status',
        textStyle: AppTextStyles.appBarHeadingText(context) ,
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
            Text(
              'Choose Ad Status',
              style: AppTextStyles.subHeadingText(context),
            ),
            SizedBox(height: 8.h),
            CustomListTile(
              path: '',
              iconColor: iconColor,
              title: 'All Ads',
              subtitle: '',
              color: Theme.of(context).scaffoldBackgroundColor,
              isMore: true,
              trailing: Icon(Icons.check, color: primary, size: 25),
            ),
            CustomListTile(
              path: '',
              iconColor: iconColor,
              title: 'Active Ads',
              subtitle: '',
              color: Theme.of(context).scaffoldBackgroundColor,
              isMore: true,
              trailing: SizedBox(),
            ),
            CustomListTile(
              path: '',
              iconColor: iconColor,
              title: 'Inactive Ads',
              subtitle: '',
              color: Theme.of(context).scaffoldBackgroundColor,
              isMore: true,
              trailing: SizedBox(),
            ),
            CustomListTile(
              path: '',
              iconColor: iconColor,
              title: 'Pending Ads',
              subtitle: '',
              color: Theme.of(context).scaffoldBackgroundColor,
              isMore: true,
              trailing: SizedBox(),
            ),
            CustomListTile(
              path: '',
              iconColor: iconColor,
              title: 'Moderated Ads',
              subtitle: '',
              color: Theme.of(context).scaffoldBackgroundColor,
              isMore: true,
              trailing: SizedBox(),
            ),
            CustomListTile(
              path: '',
              iconColor: iconColor,
              title: 'Limited Ads',
              subtitle: '',
              color: Theme.of(context).scaffoldBackgroundColor,
              isMore: true,
              trailing: SizedBox(),
            ),

            CustomListTile(
              path: '',
              iconColor: iconColor,
              title: 'Elite Ads',
              subtitle: '',
              color: Theme.of(context).scaffoldBackgroundColor,
              isMore: true,
              trailing: SizedBox(),
            ),
            CustomListTile(
              path: '',
              iconColor: iconColor,
              title: 'Featured Ads',
              subtitle: '',
              color: Theme.of(context).scaffoldBackgroundColor,
              isMore: true,
              trailing: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
