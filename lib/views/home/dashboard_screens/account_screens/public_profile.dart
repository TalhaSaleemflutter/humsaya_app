import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/views/home/dashboard_screens/account_screens/favorite_and_saved_searches_screen.dart';
import 'package:humsaya_app/widgets/custom_cards/custom_ads_card_widget.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_listtile.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';

class PublicProfileScreen extends StatefulWidget {
  const PublicProfileScreen({super.key});

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        //backgroundColor: AppColor.lightgreyColor,
        appBarHeight: 45.h,
        title: 'Public Profile',
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10.h),
              Row(
                children: [
                  Text('Welcome ', style: AppTextStyles.bodyText3(context)),
                  Text(
                    'Amna Ali ',
                    style: AppTextStyles.headingGreenText(context),
                  ),
                  Text('!', style: AppTextStyles.bodyText3(context)),
                ],
              ),
              SizedBox(height: 20.h),
              Container(
                height: 100.h, // Adjust size as needed
                width: 100.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeHelper.getCardColor(
                    context,
                  ), // Light gray background
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 50, // Adjust size as needed
                    backgroundColor: Colors.amber, // Background color
                    child: Image.asset(
                      AppAssets.girl,
                      fit: BoxFit.cover,
                      width: 80, // Match with the diameter of the CircleAvatar
                      height: 80,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Edit Profile',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyText3(
                  context,
                ).copyWith(color: blue, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40.h),
              Text('Location', style: AppTextStyles.subHeadingText(context)),
              SizedBox(height: 8.h),
              CustomListTile(
                dataIcon: Icons.location_on,
                path: '',
                iconColor: iconColor,
                title: 'Rabiya Banglows Pakistan',
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
              SizedBox(height: 18.h),
              Text(
                'Ads Published',
                style: AppTextStyles.subHeadingText(context),
              ),
              SizedBox(height: 8.h),
              CustomListTile(
                dataIcon: Icons.zoom_in,
                path: '',
                iconColor: iconColor,
                title: 'Numbers of Ads',
                subtitle: '',
                color: Theme.of(context).scaffoldBackgroundColor,
                isMore: true,
                trailing: Text('2', style: TextStyle(color: primary)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoritesAndSavedScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 18.h),
              Text('Showing Ads', style: AppTextStyles.subHeadingText(context)),
              SizedBox(height: 8.h),
              CustomAdCardWidget(
                imageUrl: AppAssets.product3, // PNG or SVG
                // statusText: 'Active',
                // statusColor: Colors.blue,
                title: 'Iphone 15',
                price: 'Rs 105,00',
                priceColor: Colors.green,
                category: 'Mobile Phones',
                categoryColor: Colors.blue,
                dateRange: 'Active from 26 Dec to 25 Jan',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
