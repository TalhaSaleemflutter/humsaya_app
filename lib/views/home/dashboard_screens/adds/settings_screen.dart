import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/views/home/dashboard_screens/adds/change_password_screen.dart';
import 'package:humsaya_app/views/home/dashboard_screens/account_screens/favorite_and_saved_searches_screen.dart';
import 'package:humsaya_app/views/home/dashboard_screens/account_screens/public_profile.dart';
import 'package:humsaya_app/views/home/dashboard_screens/adds/delivery_orders.dart';
import 'package:humsaya_app/views/home/dashboard_screens/adds/orders_&_billing_info.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_listtile.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarHeight: 45.h,
        title: 'Settings',
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
                dataIcon: Icons.privacy_tip_outlined,
                path: '',
                iconColor: iconColor,
                title: 'Privacy',
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
                dataIcon: CupertinoIcons.bell_fill,
                path: '',
                iconColor: iconColor,
                title: 'Notifications',
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
                dataIcon: Icons.delete,
                path: '',
                iconColor: iconColor,
                title: 'Change Password',
                subtitle: '',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen(),
                    ),
                  );
                },
                color: Theme.of(context).scaffoldBackgroundColor,
                isMore: true,
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: iconColor,
                  size: 17,
                ),
              ),
              CustomListTile(
                dataIcon: Icons.delete,
                path: '',
                iconColor: iconColor,
                title: 'Delete Account',
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
                dataIcon: FontAwesomeIcons.addressBook,
                path: '',
                iconColor: iconColor,
                title: 'Address Information',
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
                dataIcon: CupertinoIcons.device_laptop,
                path: '',
                iconColor: iconColor,
                title: 'User Preferences',
                subtitle: '',
                color: Theme.of(context).scaffoldBackgroundColor,
                isMore: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeliveryOrders()),
                  );
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: iconColor,
                  size: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
