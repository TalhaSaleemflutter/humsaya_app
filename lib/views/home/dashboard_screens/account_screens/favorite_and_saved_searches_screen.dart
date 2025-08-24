import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/widgets/custom_cards/custom_ads_card_widget.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';

class FavoritesAndSavedScreen extends StatefulWidget {
  const FavoritesAndSavedScreen({super.key});

  @override
  State<FavoritesAndSavedScreen> createState() =>
      _FavoritesAndSavedScreenState();
}

class _FavoritesAndSavedScreenState extends State<FavoritesAndSavedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarHeight: 45.h,
        title: 'Favorites',
        textStyle: AppTextStyles.appBarHeadingText(context),
        leadingIcon: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // Handle back button tap
            Navigator.pop(context);
          },
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
        trailingIcon: const SizedBox(), // Empty trailing icon
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.w), // Horizontal padding
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20.h), // Spacer
                    Text(
                      'All Ads',
                      style: AppTextStyles.subHeadingText(context),
                    ),
                    SizedBox(height: 10.h), // Spacer
                    // Example Ad Card
                    CustomAdCardWidget(
                      imageUrl: AppAssets.Product1,
                      statusText: 'Active',
                      statusColor: Colors.blue,
                      title: 'Iphone 15',
                      price: 'Rs 105,00',
                      priceColor: Colors.green,
                      category: 'Mobile Phones',
                      categoryColor: Colors.blue,
                      dateRange: 'Active from 26 Dec to 25 Jan',
                      showCornerIcon: true,
                      useCustomCornerContainer: true,
                      onTap: () {
                        // Handle ad card tap
                      },
                    ),
                    // Add more ad cards or widgets here
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
