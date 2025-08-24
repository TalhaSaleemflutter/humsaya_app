import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:humsaya_app/providers/ad_provider.dart';
import 'package:humsaya_app/providers/auth_provider.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/views/home/dashboard_screens/account_screens/edit_profile_screen.dart';
import 'package:humsaya_app/views/home/dashboard_screens/account_screens/favorite_and_saved_searches_screen.dart';
import 'package:humsaya_app/views/home/dashboard_screens/account_screens/public_profile.dart';
import 'package:humsaya_app/views/home/dashboard_screens/adds/delivery_orders.dart';
import 'package:humsaya_app/views/home/dashboard_screens/adds/help_and_support_screen.dart';
import 'package:humsaya_app/views/home/dashboard_screens/adds/orders_&_billing_info.dart';
import 'package:humsaya_app/views/home/dashboard_screens/adds/settings_screen.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_listtile.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_button.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isLoading = false;

  void logout() async {
    setState(() {
      isLoading = true;
    });
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout(context);
    } catch (e) {
      print('Error clearing data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarHeight: 45.h,
        title: 'Account',
        textStyle: AppTextStyles.appBarHeadingText(context),
        trailingIcon: SizedBox(),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 22.w, right: 22.w),
        child: SingleChildScrollView(
          child: Consumer2<AuthProvider, AdProvider>(
            builder: (
              BuildContext context,
              authProvider,
              addProductProvider,
              Widget? child,
            ) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Text('Welcome ', style: AppTextStyles.bodyText3(context)),
                      Text(
                        authProvider.currentUser.name.toString(),
                        style: AppTextStyles.headingGreenText(context),
                      ),
                      Text(' !', style: AppTextStyles.bodyText3(context)),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    height: 90.h,
                    width: 90.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ThemeHelper.getCardColor(context),
                    ),
                    child: Center(
                      child: CircleAvatar(
                        radius: 45.r,
                        backgroundColor: Colors.amber,
                        backgroundImage:
                            authProvider.currentUser.profileImage != null &&
                                    authProvider
                                        .currentUser
                                        .profileImage!
                                        .isNotEmpty
                                ? NetworkImage(
                                  authProvider.currentUser.profileImage!,
                                )
                                : AssetImage(AppAssets.girl) as ImageProvider,
                        child:
                            authProvider.currentUser.profileImage == null ||
                                    authProvider
                                        .currentUser
                                        .profileImage!
                                        .isEmpty
                                ? Image.asset(
                                  AppAssets.girl,
                                  fit: BoxFit.cover,
                                  width: 75.w,
                                  height: 75.h,
                                )
                                : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  GestureDetector(
                    child: Text(
                      'Edit Profile',
                      style: AppTextStyles.bodyText2(
                        context,
                      ).copyWith(color: blue, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 25.h),
                  CustomListTile(
                    dataIcon: Icons.favorite_border,
                    path: '',
                    iconColor: iconColor,
                    title: 'Favorites',
                    subtitle: '',
                    color: Theme.of(context).scaffoldBackgroundColor,
                    isMore: true,
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: iconColor,
                      size: 17.r,
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
                    dataIcon: CupertinoIcons.eye_fill,
                    path: '',
                    iconColor: iconColor,
                    title: 'Public Profile',
                    subtitle: '',
                    color: Theme.of(context).scaffoldBackgroundColor,
                    isMore: true,
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: iconColor,
                      size: 17.r,
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
                    dataIcon: FontAwesomeIcons.creditCard,
                    path: '',
                    iconColor: iconColor,
                    title: 'Buy Discounted Packages',
                    subtitle: '',
                    color: Theme.of(context).scaffoldBackgroundColor,
                    isMore: true,
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: iconColor,
                      size: 17.r,
                    ),
                  ),

                  CustomListTile(
                    dataIcon: Icons.note,
                    path: '',
                    iconColor: iconColor,
                    title: 'Orders and Billing Info',
                    subtitle: '',
                    color: Theme.of(context).scaffoldBackgroundColor,
                    isMore: true,
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: iconColor,
                      size: 17.r,
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
                    dataIcon: Icons.fire_truck,
                    path: '',
                    iconColor: iconColor,
                    title: 'Delivery Orders',
                    subtitle: '',
                    color: Theme.of(context).scaffoldBackgroundColor,
                    isMore: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeliveryOrders(),
                        ),
                      );
                    },
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: iconColor,
                      size: 17.r,
                    ),
                  ),

                  CustomListTile(
                    dataIcon: Icons.settings,
                    path: '',
                    iconColor: iconColor,
                    title: 'Settings',
                    subtitle: '',
                    color: Theme.of(context).scaffoldBackgroundColor,
                    isMore: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(),
                        ),
                      );
                    },
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: iconColor,
                      size: 17.r,
                    ),
                  ),
                  CustomListTile(
                    dataIcon: FontAwesomeIcons.handshake,
                    path: '',
                    iconColor: iconColor,
                    title: 'Help & Support',
                    subtitle: '',
                    color: Theme.of(context).scaffoldBackgroundColor,
                    isMore: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HelpAndSupportScreen(),
                        ),
                      );
                    },
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: iconColor,
                      size: 17.r,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CustomButton(
                    txtColor: white,
                    bgColor: primary,
                    text: 'Log Out',
                    onTap: () {
                      logout();
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
