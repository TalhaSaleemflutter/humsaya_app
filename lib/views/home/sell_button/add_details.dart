import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/models/ad_product_model.dart';
import 'package:humsaya_app/providers/ad_provider.dart';
import 'package:humsaya_app/providers/auth_provider.dart';
import 'package:humsaya_app/providers/category_provider.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/views/home/dashboard_screens/ad_discription_screen.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_table.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_button.dart';
import 'package:provider/provider.dart';

class AdDetailScreen extends StatefulWidget {
  final AdModel adModel;
  const AdDetailScreen({super.key, required this.adModel});

  @override
  State<AdDetailScreen> createState() => _AdDetailScreenState();
}

class _AdDetailScreenState extends State<AdDetailScreen> {
  final PageController _pageController = PageController();
  AdModel? adModel;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  void _fetchLocation() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.fetchCurrentLocationWithAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        //backgroundColor: AppColor.lightgreyColor,
        appBarHeight: 50.h,
        title: 'My Details',
        textStyle: AppTextStyles.appBarHeadingText(context),
        leadingIcon: Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            AppAssets.icBack,
            height: 20.h,
            width: 20.w,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        trailingIcon: SizedBox(),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 22.w, right: 22.w),
        child: Consumer3<AdProvider, AuthProvider, CategoryProvider>(
          builder: (
            BuildContext context,
            adProvider,
            authProvider,
            categoryProvider,
            Widget? child,
          ) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        SizedBox(
                          height: 180.h,
                          width: 44.w,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount:
                                widget
                                    .adModel
                                    .listOfImages
                                    .length, // Dynamic length
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    8.0,
                                  ), // Adjust the radius as needed
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/icons/hori_line.png',
                                    image: widget.adModel.listOfImages[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.adModel.listOfImages.length,
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
                        SizedBox(height: 15.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment:
                                  Alignment
                                      .centerLeft, // Ensures text starts from left
                              child: Text(
                                'Rs ${widget.adModel.price.toString()}',
                                style: AppTextStyles.bodyText4(
                                  context,
                                ).copyWith(
                                  fontSize: 24.sp,
                                  // color: primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                ContainerIcon(
                                  icon: Icons.share,
                                  iconColor: ThemeHelper.getBlackWhite(context),
                                  onTap: () {},
                                ),
                                SizedBox(width: 10.w),
                                ContainerIcon(
                                  icon: Icons.favorite_outline,
                                  iconColor: ThemeHelper.getBlackWhite(context),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          widget.adModel.title.toString(),
                          style: AppTextStyles.bodyText2(context).copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: ThemeHelper.getBlackWhite(context),
                                  size: 22.sp,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  authProvider.currentAddress.toString(),
                                  style: AppTextStyles.bodyText2(
                                    context,
                                  ).copyWith(fontSize: 14.sp),
                                ),
                              ],
                            ),
                            Text(
                              adProvider.calculateDateDifference(
                                widget.adModel.createdAt.toString(),
                              ),
                              style: AppTextStyles.bodyText2(
                                context,
                              ).copyWith(fontSize: 12.sp),
                            ),
                          ],
                        ),

                        SizedBox(height: 22.h),
                        Padding(
                          padding: EdgeInsets.only(left: 20.w, right: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconContainer(
                                onTap: () {},
                                icon: Icons.edit,
                                iconColor: ThemeHelper.getBlackWhite(context),
                              ),
                              const SizedBox(width: 10),
                              IconContainer(
                                onTap: () {},
                                icon: Icons.delete,
                                iconColor: ThemeHelper.getBlackWhite(context),
                              ),
                              const SizedBox(width: 10),
                              IconContainer(
                                onTap: () {
                                  _showCustomBottomSheet(context);
                                },
                                icon: Icons.more_horiz,
                                iconColor: ThemeHelper.getBlackWhite(context),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                        // CustomInfoCard(
                        //   title: "Reach more buyers",
                        //   description:
                        //       "Feature or boost your ad on\ntop to reach more clients ",
                        //   additionalText: "Sell more faster",
                        //   trailingIconPath: AppAssets.exportIcon,
                        //   backgroundColor: ThemeHelper.getBackgroundCardColor(
                        //     context,
                        //   ),
                        //   // Light blue background
                        //   isSvg: false, // Set to false if using PNG
                        // ),
                        // const SizedBox(height: 18),
                        // Text(
                        //   'Insights',
                        //   style: AppTextStyles.subHeadingText(context),
                        // ),
                        // const SizedBox(height: 8),
                        // CustomListTile(
                        //   dataIcon: CupertinoIcons.eye_fill,
                        //   path: '',
                        //   iconColor: iconColor,
                        //   title: 'Views',
                        //   subtitle: '',
                        //   color: Theme.of(context).scaffoldBackgroundColor,
                        //   isMore: true,
                        //   trailing: Text(
                        //     '18',
                        //     style: TextStyle(
                        //       fontSize: 14,
                        //       fontWeight: FontWeight.bold,
                        //       color: primary,
                        //     ),
                        //   ),
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => const YourPlanScreen(),
                        //       ),
                        //     );
                        //   },
                        // ),
                        // CustomListTile(
                        //   dataIcon: FontAwesomeIcons.userCheck,
                        //   path: '',

                        //   iconColor: iconColor,
                        //   title: 'Leads',
                        //   subtitle: '',
                        //   color: Theme.of(context).scaffoldBackgroundColor,
                        //   isMore: true,
                        //   trailing: Text(
                        //     '8',
                        //     style: TextStyle(
                        //       fontSize: 14,
                        //       fontWeight: FontWeight.bold,
                        //       color: primary,
                        //     ),
                        //   ),
                        // ),
                        // CustomListTile(
                        //   dataIcon: FontAwesomeIcons.commentDots,
                        //   path: '',
                        //   iconColor: iconColor,
                        //   title: 'Chats',
                        //   subtitle: '',
                        //   color: Theme.of(context).scaffoldBackgroundColor,
                        //   isMore: true,
                        //   trailing: Text(
                        //     '1',
                        //     style: TextStyle(
                        //       fontSize: 14,
                        //       fontWeight: FontWeight.bold,
                        //       color: primary,
                        //     ),
                        //   ),
                        // ),
                        // CustomListTile(
                        //   dataIcon: CupertinoIcons.phone,
                        //   path: '',
                        //   iconColor: iconColor,
                        //   title: 'Phone',
                        //   subtitle: '',
                        //   color: Theme.of(context).scaffoldBackgroundColor,
                        //   isMore: true,
                        //   trailing: Text(
                        //     '26',
                        //     style: TextStyle(
                        //       fontSize: 14,
                        //       fontWeight: FontWeight.bold,
                        //       color: primary,
                        //     ),
                        //   ),
                        // ),
                        Text(
                          'Details',
                          style: AppTextStyles.subHeadingText(context),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomRow(
                              backgroundColor: ThemeHelper.getCardColor(
                                context,
                              ),
                              title: "Category",
                              value:
                                  categoryProvider
                                      .getCategoryById(
                                        widget.adModel.categoryId,
                                      )
                                      ?.title ??
                                  'Category not found',
                            ),
                            CustomRow(
                              backgroundColor: ThemeHelper.getWhiteBlackColor(
                                context,
                              ),
                              title: "Brand",
                              value: widget.adModel.brandName,
                            ),

                            // CustomRow(
                            //   title: "Model",
                            //   value: "Pro Max",
                            //   backgroundColor: ThemeHelper.getWhiteBlackColor(
                            //     context,
                            //   ),
                            // ),
                            (categoryProvider
                                            .getCategoryById(
                                              widget.adModel.categoryId,
                                            )
                                            ?.categoryId ??
                                        '') ==
                                    '2'
                                ? CustomRow(
                                  backgroundColor: ThemeHelper.getCardColor(
                                    context,
                                  ),
                                  title: "Service Type",
                                  value: widget.adModel.servicePaymentType,
                                )
                                : (categoryProvider
                                            .getCategoryById(
                                              widget.adModel.categoryId,
                                            )
                                            ?.categoryId ??
                                        '') ==
                                    '3'
                                ? CustomRow(
                                  backgroundColor: ThemeHelper.getCardColor(
                                    context,
                                  ),
                                  title: "Url",
                                  isUrl: true,
                                  value: widget.adModel.websiteUrl,
                                )
                                : CustomRow(
                                  backgroundColor: ThemeHelper.getCardColor(
                                    context,
                                  ),
                                  title: "Condition",
                                  value: widget.adModel.condition,
                                ),

                            // CustomRow(
                            //   backgroundColor: ThemeHelper.getCardColor(
                            //     context,
                            //   ),
                            //   title: "Service Type",
                            //   value: widget.adModel.servicePaymentType,
                            // ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Description',
                          style: AppTextStyles.subHeadingText(context),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.adModel.description.toString(),
                          style: AppTextStyles.bodyText2(
                            context,
                          ).copyWith(fontSize: 14.sp),
                        ),

                        // Text(
                        //   'Location',
                        //   style: AppTextStyles.subHeadingText(context),
                        // ),
                        // const SizedBox(height: 4),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Row(
                        //       children: [
                        //         Icon(Icons.location_on, color: primary),
                        //         SizedBox(width: 5.w),
                        //         Text(
                        //           "Use current location",
                        //           textAlign: TextAlign.center,
                        //           style: AppTextStyles.headingGreenText(
                        //             context,
                        //           ),
                        //         ),
                        //       ],
                        //     ),

                        //     Text(
                        //       "Ad ID: 109678143",
                        //       textAlign: TextAlign.center,
                        //       style: AppTextStyles.bodyText2(
                        //         context,
                        //       ).copyWith(fontSize: 13.sp),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 10),
                        // SizedBox(
                        //   height: 150.h,
                        //   child: Stack(
                        //     alignment: Alignment.center,
                        //     children: [
                        //       Container(
                        //         decoration: BoxDecoration(
                        //           color: ThemeHelper.getCardColor(context),
                        //           borderRadius: BorderRadius.circular(12),
                        //           border: Border.all(
                        //             width: 0.8,
                        //             color: Colors.grey,
                        //           ),
                        //         ),
                        //         child: GridView.builder(
                        //           physics: const NeverScrollableScrollPhysics(),
                        //           gridDelegate:
                        //               const SliverGridDelegateWithFixedCrossAxisCount(
                        //                 crossAxisCount: 5,
                        //                 crossAxisSpacing: 8,
                        //                 mainAxisSpacing: 8,
                        //               ),
                        //           itemCount: 25,
                        //           itemBuilder: (context, index) {
                        //             return Container(
                        //               color:
                        //                   Colors
                        //                       .transparent, // Blank grid items
                        //             );
                        //           },
                        //         ),
                        //       ),
                        //       const Icon(
                        //         Icons.circle,
                        //         color: Colors.blue,
                        //         size: 16,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(height: 25.h),
                        CustomButton(
                          txtColor: white,
                          bgColor: primary,
                          text: 'Sold Out',
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => const LoginPage()),
                            // );
                          },
                        ),
                        SizedBox(height: 20.h),
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

class IconContainer extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const IconContainer({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap!,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ThemeHelper.getCardColor(context),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }
}

void _showCustomBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.delete,
                color: ThemeHelper.getBlackWhite(context),
              ),
              title: Text(
                'Delete Ad',
                style: TextStyle(color: ThemeHelper.getBlackWhite(context)),
              ),
              onTap: () {
                // Handle delete action
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
            ListTile(
              leading: Icon(
                Icons.edit,
                color: ThemeHelper.getBlackWhite(context),
              ),
              title: Text(
                'Edit Ad',
                style: TextStyle(color: ThemeHelper.getBlackWhite(context)),
              ),
              onTap: () {
                // Handle edit action
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
            ListTile(
              leading: Icon(
                color: ThemeHelper.getBlackWhite(context),
                Icons.check_circle,
              ),
              title: Text(
                'Mark as sold',
                style: TextStyle(color: ThemeHelper.getBlackWhite(context)),
              ),
              onTap: () {
                // Handle edit action
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.share,
                color: ThemeHelper.getBlackWhite(context),
              ),
              title: Text(
                'Share',
                style: TextStyle(color: ThemeHelper.getBlackWhite(context)),
              ),
              onTap: () {
                // Handle share action
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

// class CustomRow extends StatelessWidget {
//   final String title;
//   final String value;
//   final Color backgroundColor;

//   const CustomRow({
//     Key? key,
//     required this.title,
//     required this.value,
//     required this.backgroundColor,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: backgroundColor,
//       padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 140.w,
//             child: Text(
//               title,
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//               textAlign: TextAlign.left,
//               softWrap: true,
//               overflow: TextOverflow.visible,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
