import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/models/ad_product_model.dart';
import 'package:humsaya_app/models/category_model.dart';
import 'package:humsaya_app/providers/ad_provider.dart';
import 'package:humsaya_app/providers/auth_provider.dart';
import 'package:humsaya_app/providers/category_provider.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/views/home/dashboard_screens/chat/Live_chatting_screen.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_table.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_button.dart';
import 'package:provider/provider.dart';

class AdDescriptionScreen extends StatefulWidget {
  final AdModel adModel;

  const AdDescriptionScreen({super.key, required this.adModel});
  @override
  State<AdDescriptionScreen> createState() => _AdDescriptionScreenState();
}

class _AdDescriptionScreenState extends State<AdDescriptionScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        //backgroundColor: AppColor.lightgreyColor,
        appBarHeight: 45.h,
        title: 'Iphone ad',
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Consumer3<CategoryProvider, AuthProvider, AdProvider>(
                  builder: (
                    BuildContext context,
                    categoryProvider,
                    authProvider,
                    adProvider,
                    Widget? child,
                  ) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        SizedBox(
                          height: 180.h,
                          width: 44.w,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: widget.adModel.listOfImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
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
                        SizedBox(height: 10.h),
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
                                SizedBox(
                                  width: 6.w,
                                ), // Small space between icon and text
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
                              ).copyWith(fontSize: 14.sp),
                            ),
                          ],
                        ),

                        // Padding(
                        //   padding: EdgeInsets.only(left: 20.w, right: 20.w),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //     children: [
                        //       IconContainer(
                        //         icon: Icons.notifications,
                        //         iconColor: ThemeHelper.getBlackWhite(context),
                        //       ),
                        //       const SizedBox(width: 10),
                        //       IconContainer(
                        //         icon: FontAwesomeIcons.handHoldingDollar,
                        //         iconColor: ThemeHelper.getBlackWhite(context),
                        //       ),
                        //       const SizedBox(width: 10),
                        //       IconContainer(
                        //         icon: FontAwesomeIcons.share,
                        //         iconColor: ThemeHelper.getBlackWhite(context),
                        //       ),
                        //       const SizedBox(width: 10),
                        //       IconContainer(
                        //         icon: Icons.favorite,
                        //         iconColor: ThemeHelper.getBlackWhite(context),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(height: 30.h),
                        // Container(
                        //   padding: EdgeInsets.all(18.sp),
                        //   decoration: BoxDecoration(
                        //     color: ThemeHelper.getCardColor(context),
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       const Text(
                        //         "Chat with seller",
                        //         style: TextStyle(fontWeight: FontWeight.bold),
                        //       ),
                        //       const SizedBox(height: 10),
                        //       Row(
                        //         children: [
                        //           Expanded(
                        //             child: Container(
                        //               height: 50.h,
                        //               child: TextField(
                        //                 decoration: InputDecoration(
                        //                   hintText: "Is this available?",
                        //                   border: OutlineInputBorder(
                        //                     borderRadius: BorderRadius.circular(
                        //                       30,
                        //                     ),
                        //                     borderSide: BorderSide.none,
                        //                   ),
                        //                   filled: true,
                        //                   fillColor:
                        //                       ThemeHelper.getWhiteBlackColor(
                        //                         context,
                        //                       ),
                        //                   contentPadding: EdgeInsets.only(
                        //                     left: 25,
                        //                     top: 12,
                        //                     bottom: 4,
                        //                   ), // Left padding & vertical centering
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //           const SizedBox(width: 10),
                        //           ElevatedButton(
                        //             style: ElevatedButton.styleFrom(
                        //               backgroundColor: Colors.green,
                        //               padding: const EdgeInsets.symmetric(
                        //                 horizontal: 8,
                        //                 vertical: 4,
                        //               ),
                        //               shape: RoundedRectangleBorder(
                        //                 borderRadius: BorderRadius.circular(
                        //                   8,
                        //                 ), // Reduced corner radius
                        //               ),
                        //             ),
                        //             onPressed: () {},
                        //             child: const Text(
                        //               "Send",
                        //               style: TextStyle(color: Colors.white),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(height: 15.h),
                        Text(
                          'Description',
                          style: AppTextStyles.subHeadingText(context),
                        ),
                        SizedBox(height: 6.h),
                        (widget.adModel.categoryId != '1')
                            ? CustomRow(
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
                            )
                            : SizedBox.shrink(),
                        CustomRow(
                          backgroundColor: ThemeHelper.getWhiteBlackColor(
                            context,
                          ),
                          title: "Brand",
                          value: widget.adModel.brandName,
                        ),
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

                        SizedBox(height: 15.h),
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
                        SizedBox(height: 110.h),
                        widget.adModel.categoryId != '1'
                            ? SizedBox.shrink()
                            : SizedBox(height: 40.h),

                        CustomButton(
                          txtColor: white,
                          bgColor: primary,
                          text: 'Chat with seller',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => LiveChattingScreen(
                                      adId: widget.adModel.addId,
                                      receiverId: widget.adModel.uid,
                                      receiverName:
                                          widget.adModel.brandName ?? 'Seller',
                                      adModel: widget.adModel,
                                      receiverUserEmail: '',
                                      userAvatar: '',
                                      lastMessage: '',
                                      userName: '',
                                    ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContainerIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const ContainerIcon({
    super.key,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ThemeHelper.getCardColor(context),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }
}
