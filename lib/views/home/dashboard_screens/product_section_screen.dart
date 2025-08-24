import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:humsaya_app/models/category_model.dart';
import 'package:humsaya_app/providers/ad_provider.dart';
import 'package:humsaya_app/providers/auth_provider.dart';
import 'package:humsaya_app/providers/category_provider.dart';
import 'package:humsaya_app/providers/notification_provider.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/views/home/dashboard_screens/adds/show_all_ads.dart';
import 'package:humsaya_app/views/home/dashboard_screens/ad_discription_screen.dart';
import 'package:humsaya_app/views/home/push_notifications.dart';
import 'package:humsaya_app/widgets/custom_cards/custom_card.dart';
import 'package:provider/provider.dart';

class ProductSectionScreen extends StatefulWidget {
  final CategoryModel categoryModel;
  const ProductSectionScreen({super.key, required this.categoryModel});

  @override
  State<ProductSectionScreen> createState() => _ProductSectionScreenState();
}

class _ProductSectionScreenState extends State<ProductSectionScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 22.w, right: 22.w),
        child: Consumer3<AdProvider, CategoryProvider, AuthProvider>(
          builder: (
            BuildContext context,
            adProvider,
            categoryProvider,
            authProvider,
            Widget? child,
          ) {
            final discountedProducts =
                adProvider.products
                    .where(
                      (ad) => ad.discountPrice != null && ad.discountPrice > 0,
                    )
                    .toList();
            return Column(
              children: [
                SizedBox(height: 50.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(height: 37.h, width: 37.w, AppAssets.appLogo),
                    Container(
                      width: 240.w,
                      decoration: BoxDecoration(
                        color: ThemeHelper.getCardColor(context),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        onTap: () {},
                        decoration: InputDecoration(
                          hintText: 'Sear',
                          prefixIcon: Icon(
                            Icons.search,
                            color: ThemeHelper.getTabbarTextColor(
                              context,
                              false,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    Consumer<NotificationProvider>(
                      builder: (context, provider, _) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const PushNotifications(),
                                  ),
                                );
                              },
                              child: Icon(
                                CupertinoIcons.bell,
                                size: 30.sp,
                                color: ThemeHelper.getBlackWhite(context),
                              ),
                            ),

                            if (provider.unreadCount > 0)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  child: Text(
                                    '${provider.unreadCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.w, right: 10.w),
                          child: Row(
                            children: [
                              Icon(Icons.place_outlined),
                              SizedBox(width: 5.w),
                              Text(
                                'Use current location',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.headingGreenText(
                                  context,
                                ).copyWith(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        SizedBox(
                          height: 180.h,
                          child: PageView(
                            controller: _pageController,
                            //viewportFraction: 0.8,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Image.asset(AppAssets.image2),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Image.asset(AppAssets.image2),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Image.asset(AppAssets.image2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (index) => AnimatedBuilder(
                              animation: _pageController,
                              builder: (context, child) {
                                double selectedPage =
                                    _pageController.hasClients
                                        ? _pageController.page ?? 0
                                        : 0;
                                bool isSelected = selectedPage.round() == index;
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                                  width: isSelected ? 12.w : 8.w,
                                  height: isSelected ? 12.h : 8.h,
                                  decoration: BoxDecoration(
                                    color: isSelected ? primary : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Padding(
                          padding: EdgeInsets.only(left: 1.w, right: 1.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Discounts',
                                style: AppTextStyles.subHeadingText(context),
                              ),
                              GestureDetector(
                                child: Text(
                                  'See all',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.headingGreenText(
                                    context,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ShowAllAdsScreen(
                                            categoryModel: widget.categoryModel,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        SizedBox(
                          height: 250.h,
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0),
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                discountedProducts
                                    .where(
                                      (product) =>
                                          product.categoryId ==
                                          widget.categoryModel.categoryId,
                                    )
                                    .length,
                            itemBuilder: (context, index) {
                              final filteredProducts =
                                  discountedProducts
                                      .where(
                                        (product) =>
                                            product.categoryId ==
                                            widget.categoryModel.categoryId,
                                      )
                                      .toList();

                              final value = filteredProducts[index];
                              final images = value.listOfImages;
                              if (images.isEmpty) {
                                return const SizedBox();
                              }
                              return Padding(
                                padding: EdgeInsets.only(right: 20.w),
                                child: CustomProductCard(
                                  backgroundImages: [NetworkImage(images.last)],
                                  image: Image.asset(AppAssets.image2),
                                  price: value.price.toString(),
                                  title: value.title,
                                  description: value.description.toString(),
                                  time: value.createdAt.toString(),
                                  offerText:
                                      index % 2 == 0 ? "20% OFF" : "10% OFF",
                                  offerBgColor: Colors.red,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => AdDescriptionScreen(
                                              adModel: value,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                        // SizedBox(
                        //   height: 250.h,
                        //   child: NotificationListener<ScrollNotification>(
                        //     onNotification: (scrollNotification) {
                        //       if (scrollNotification is ScrollEndNotification &&
                        //           scrollNotification.metrics.pixels ==
                        //               scrollNotification
                        //                   .metrics
                        //                   .maxScrollExtent &&
                        //           !adProvider.isLoading &&
                        //           adProvider.hasMore) {
                        //         final userId =
                        //             authProvider.currentUser?.uid ?? '';
                        //         if (userId.isNotEmpty) {
                        //           adProvider.loadMoreAds(context, userId);
                        //         }
                        //         return true;
                        //       }
                        //       return false;
                        //     },
                        //     child: ListView.builder(
                        //       shrinkWrap: true,
                        //       padding: EdgeInsets.all(0),
                        //       scrollDirection: Axis.horizontal,
                        //       itemCount:
                        //           adProvider.products.length +
                        //           (adProvider.hasMore ? 1 : 0),
                        //       itemBuilder: (context, index) {
                        //         if (index == adProvider.products.length) {
                        //           // Show loading indicator at the end
                        //           return Center(
                        //             child: Padding(
                        //               padding: EdgeInsets.all(8.0),
                        //               child: CircularProgressIndicator(),
                        //             ),
                        //           );
                        //         }

                        //         final value = adProvider.products[index];
                        //         final images = value.listOfImages;
                        //         if (images.isEmpty) {
                        //           return const SizedBox();
                        //         }
                        //         return Padding(
                        //           padding: EdgeInsets.only(right: 20.w),
                        //           child: CustomProductCard(
                        //             backgroundImages: [
                        //               NetworkImage(images.last),
                        //             ],
                        //             image: Image.asset(AppAssets.image2),
                        //             price: value.price.toString(),
                        //             title: value.title,
                        //             description: value.description.toString(),
                        //             time: value.createdAt.toString(),
                        //             offerText:
                        //                 index % 2 == 0 ? "20% OFF" : "10% OFF",
                        //             offerBgColor: Colors.red,
                        //             onTap: () {
                        //               Navigator.of(context).push(
                        //                 MaterialPageRoute(
                        //                   builder:
                        //                       (context) => AdDescriptionScreen(
                        //                         adModel: value,
                        //                       ),
                        //                 ),
                        //               );
                        //             },
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 20.h),
                        // Padding(
                        //   padding: EdgeInsets.only(left: 3.w, right: 3.w),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         'Featured',
                        //         style: AppTextStyles.subHeadingText(context),
                        //       ),
                        //       Text(
                        //         'See all',
                        //         textAlign: TextAlign.center,
                        //         style: AppTextStyles.headingGreenText(context),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(height: 8.h),
                        // SizedBox(
                        //   height: 210.h, // Adjust height as needed
                        //   child: ListView.builder(
                        //     scrollDirection:
                        //         Axis.horizontal, // Enable horizontal scrolling
                        //     itemCount: 4, // Number of items
                        //     itemBuilder: (context, index) {
                        //       return Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //           horizontal: 4.0,
                        //         ), // Adjust spacing
                        //         child: CustomProductCard(
                        //           image: Image.asset(AppAssets.image2),
                        //           price: "Rs 24,500",
                        //           title: "redmi note 10",
                        //           description:
                        //               "Rabia Bungalows Road, Rawalpindi",
                        //           time: "12 Days ago",
                        //           offerText:
                        //               index % 2 == 0 ? "20% OFF" : "10% OFF",
                        //           offerBgColor: Colors.red,
                        //           onTap: () {
                        //             Navigator.of(context).push(
                        //               MaterialPageRoute(
                        //                 builder:
                        //                     (context) => const ProductScreen(),
                        //               ),
                        //             );
                        //           },
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                        // SizedBox(height: 20.h),
                        // Padding(
                        //   padding: EdgeInsets.only(left: 3.w, right: 3.w),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         'Frequently used',
                        //         style: AppTextStyles.subHeadingText(context),
                        //       ),
                        //       Text(
                        //         'See all',
                        //         textAlign: TextAlign.center,
                        //         style: AppTextStyles.headingGreenText(context),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(height: 8.h),
                        // SizedBox(
                        //   height: 210.h, // Adjust height as needed
                        //   child: ListView.builder(
                        //     scrollDirection:
                        //         Axis.horizontal, // Enable horizontal scrolling
                        //     itemCount: 4, // Number of items
                        //     itemBuilder: (context, index) {
                        //       return Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //           horizontal: 4.0,
                        //         ), // Adjust spacing
                        //         child: CustomProductCard(
                        //           image: Image.asset(AppAssets.image2),
                        //           price: "Rs 24,500",
                        //           title: "redmi note 10",
                        //           description:
                        //               "Rabia Bungalows Road, Rawalpindi",
                        //           time: "12 Days ago",
                        //           offerText:
                        //               index % 2 == 0 ? "20% OFF" : "10% OFF",
                        //           offerBgColor: Colors.red,
                        //           onTap: () {
                        //             Navigator.of(context).push(
                        //               MaterialPageRoute(
                        //                 builder:
                        //                     (context) => const ProductScreen(),
                        //               ),
                        //             );
                        //           },
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                        // SizedBox(height: 20.h),
                      ],
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
