import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:humsaya_app/models/ad_product_model.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/views/home/dashboard_screens/ad_discription_screen.dart';
import 'package:humsaya_app/widgets/custom_cards/custom_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 22.w, right: 22.w),
        child: Column(
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
                      hintText: 'Searc ',
                      prefixIcon: Icon(
                        Icons.search,
                        color: ThemeHelper.getTabbarTextColor(context, false),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const PushNotification(id: ''),
                    //   ),
                    // );
                  },
                  child: Icon(
                    size: 30.sp,
                    CupertinoIcons.bell,
                    color: ThemeHelper.getBlackWhite(context),
                  ),
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
                            ).copyWith(fontSize: 16.sp),
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                            ), // Adjust the horizontal padding
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: AppTextStyles.subHeadingText(context),
                        ),
                        Text(
                          'See all',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headingGreenText(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CategoryItem(
                            color: blue,
                            icon: Icons.smartphone,
                            text: "Mobiles",
                          ),
                          SizedBox(width: 8.w), // Add horizontal space
                          CategoryItem(
                            color: teal,
                            icon: Icons.directions_car,
                            text: "Vehicles",
                          ),
                          SizedBox(width: 8.w), // Add horizontal space
                          CategoryItem(
                            color: yellow1,
                            icon: Icons.build,
                            text: "Services",
                          ),
                          SizedBox(width: 8.w), // Add horizontal space
                          CategoryItem(
                            color: orange,
                            icon: Icons.pets,
                            text: "Animals",
                          ),
                          SizedBox(width: 8.w), // Add horizontal space
                          CategoryItem(
                            color: Colors.green,
                            icon: Icons.computer,
                            text: "Jobs",
                          ),
                          SizedBox(width: 8.w),
                          CategoryItem(
                            color: blue,
                            icon: Icons.smartphone,
                            text: "Mobiles",
                          ),
                          SizedBox(width: 8.w),
                          CategoryItem(
                            color: teal,
                            icon: Icons.directions_car,
                            text: "Vehicles",
                          ),
                          SizedBox(width: 8.w), // Add horizontal space
                          CategoryItem(
                            color: yellow1,
                            icon: Icons.build,
                            text: "Services",
                          ),
                          SizedBox(width: 8.w),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mobile phones',
                          style: AppTextStyles.subHeadingText(context),
                        ),
                        Text(
                          'See all',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headingGreenText(context),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 900.h,
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 8,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.85,
                            ),
                        itemBuilder: (context, index) {
                          return CustomProductCard(
                            image: Image.asset(AppAssets.image2),
                            price: "Rs 24,500",
                            title: "redmi note 10",
                            description: "Rabia Bungalows Road, Rawalpindi",
                            time: "12 Days ago",
                            offerText: index % 2 == 0 ? "20% OFF" : "10% OFF",
                            offerBgColor: Colors.red,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => AdDescriptionScreen(
                                        adModel: AdModel(
                                          uid: '',
                                          addId: '',
                                          title: '',
                                          description: '',
                                          price: 0,
                                          condition: '',
                                          location: '',
                                          listOfImages: [],
                                          brandName: '',
                                          createdAt: DateTime.now(),
                                          isActive: false,
                                          categoryId: '',
                                          servicePaymentType: '',
                                          websiteUrl: '',
                                          discountPrice: 0.0,
                                        ),
                                      ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
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

class CategoryItem extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;

  const CategoryItem({
    Key? key,
    required this.color,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
