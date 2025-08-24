import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/views/home/dashboard_screens/account_screens/favorite_and_saved_searches_screen.dart';
import 'package:humsaya_app/views/home/dashboard_screens/account_screens/public_profile.dart';
import 'package:humsaya_app/views/home/dashboard_screens/adds/orders_&_billing_info.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_listtile.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarHeight: 45.h,
        title: 'Help and Support',
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
        padding: EdgeInsets.only(left: 22.w, right: 22.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              CustomListTile(
                dataIcon: FontAwesomeIcons.handshake,
                path: '',
                iconColor: iconColor,
                title: 'Help Center',
                subtitle: '',
                color: Theme.of(context).scaffoldBackgroundColor,
                isMore: true,
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: iconColor,
                  size: 17,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoritesAndSavedScreen(),
                    ),
                  );
                },
              ),
              CustomListTile(
                dataIcon: Icons.feedback,
                path: '',
                iconColor: iconColor,
                title: 'FeedBack',
                subtitle: '',
                color: Theme.of(context).scaffoldBackgroundColor,
                isMore: true,
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: iconColor,
                  size: 17,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PublicProfileScreen(),
                    ),
                  );
                },
              ),

              CustomListTile(
                dataIcon: FontAwesomeIcons.userGroup,
                iconSize: 18,
                path: '',
                iconColor: iconColor,
                title: 'Invite friends to Humsaya',
                subtitle: '',
                color: Theme.of(context).scaffoldBackgroundColor,
                isMore: true,
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: iconColor,
                  size: 17,
                ),
              ),

              CustomListTile(
                dataIcon: FontAwesomeIcons.codeBranch,
                path: '',
                iconColor: iconColor,
                title: 'Submit Request',
                subtitle: '',
                color: Theme.of(context).scaffoldBackgroundColor,
                isMore: true,
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: iconColor,
                  size: 17,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrdersAndBillingInfo(),
                    ),
                  );
                },
              ),
              CustomListTile(
                path: '',
                iconColor: iconColor,
                title: '   Version (15.54467)',
                subtitle: '',
                color: Theme.of(context).scaffoldBackgroundColor,
                isMore: true,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrdersAndBillingInfo(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
