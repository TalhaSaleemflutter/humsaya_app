import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:humsaya_app/providers/ad_provider.dart';
import 'package:humsaya_app/providers/auth_provider.dart';
import 'package:humsaya_app/providers/category_provider.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/views/home/dashboard_screens/adds/filter_screen.dart';
import 'package:humsaya_app/views/home/sell_button/add_details.dart';
import 'package:humsaya_app/widgets/custom_cards/custom_ads_card_widget.dart';
import 'package:humsaya_app/widgets/custom_cards/custom_info_cards.dart';
import 'package:humsaya_app/widgets/custom_sheets/custom_bottom_sheet.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key});

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  bool _initialLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adProvider = Provider.of<AdProvider>(context, listen: false);
      if (adProvider.myAds.isEmpty) {
        _loadAds();   
      } else {
        setState(() => _initialLoading = false);
      }
    });
  }

  Future<void> _loadAds() async {
    final adProvider = Provider.of<AdProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() => _initialLoading = true);
    try {
      await adProvider.getMyAds(context, authProvider.currentUser.uid);
      if (adProvider.myAds.isEmpty) {
        await adProvider.loadMyAdsFromHive(authProvider.currentUser.uid);
      }
    } finally {
      if (mounted) {
        setState(() => _initialLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarHeight: 45.h,
        title: 'My Ads',
        textStyle: AppTextStyles.appBarHeadingText(context),
        trailingIcon: const SizedBox(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: Consumer3<AdProvider, CategoryProvider, AuthProvider>(
          builder: (
            context,
            adProvider,
            categoryProvider,
            authProvider,
            child,
          ) {
            final myAds = adProvider.myAds;
            if (_initialLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                CustomInfoCard(
                  title: "Reach more buyers",
                  description:
                      "Feature or boost your ad on\ntop to reach more clients",
                  additionalText: "Sell more faster",
                  trailingIconPath: AppAssets.exportIcon,
                  backgroundColor: ThemeHelper.getBackgroundCardColor(context),
                  isSvg: false,
                ),
                SizedBox(height: 20.h),
                Text('All Ads', style: AppTextStyles.subHeadingText(context)),
                SizedBox(height: 10.h),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadAds,
                    child:
                        myAds.isEmpty
                            ? Center(
                              child: Text(
                                'No ads found',
                                style: AppTextStyles.subHeadingText(context),
                              ),
                            )
                              : ListView.builder(
                                itemCount: myAds.length,
                                itemBuilder: (context, index) {
                                  final ad = myAds[index];
                                  final images = ad.listOfImages;
                                  if (images.isEmpty) return const SizedBox();
                                  return Padding(
                                    padding: EdgeInsets.only(top: 8.h),
                                    child: CustomAdCardWidget(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    AdDetailScreen(adModel: ad),
                                          ),
                                        );
                                      },
                                      imageUrl: '',
                                      backgroundImages: [
                                        NetworkImage(images.last),
                                      ],
                                      statusText: ad.brandName,
                                      statusColor: Colors.lightBlue,
                                      title: ad.title,
                                      price: ad.price.toString(),
                                      priceColor: Colors.green,
                                      category: ad.description,
                                      categoryColor: Colors.blue,
                                      soldText: ad.isSold == false ? '' : 'Sold',

                                      dateRange: 'Active from 26 Dec to 25 Jan',
                                      showCornerIcon: true,
                                      onCornerIconTap: () {
                                        CustomBottomSheet.show(
                                          context,
                                          items: [
                                            BottomSheetItem(
                                              icon: Icons.share,
                                              title: 'Share',
                                              iconColor: Colors.blueGrey,
                                              onTap: () {},
                                            ),
                                            BottomSheetItem(
                                              icon: Icons.edit,
                                              title: 'Edit Ad',
                                              iconColor: Colors.blue,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            const FilterScreen(),
                                                  ),
                                                );
                                              },
                                            ),

                                            BottomSheetItem(
                                              icon: Icons.check_circle,
                                              title: 'Mark as Sold',
                                              iconColor: Colors.green,
                                              onTap: () {
                                                adProvider.markAdAsSold(
                                                  ad.addId,
                                                  context,
                                                );
                                              },
                                            ),

                                            BottomSheetItem(
                                              icon: Icons.delete,
                                              title: 'Delete Ad',
                                              iconColor: Colors.red,
                                              onTap: () async {
                                                await adProvider.deleteAd(
                                                  ad,
                                                  context,
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
