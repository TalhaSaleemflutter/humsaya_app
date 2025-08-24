import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';

class CustomAdCardWidget extends StatelessWidget {
  final String imageUrl;
  final String? statusText;
  final Color? statusColor;
  final String title;
  final String? soldText;
  final String price;
  final Color priceColor;
  final String category;
  final Color categoryColor;
  final String dateRange;
  final bool showCornerIcon;
  final VoidCallback? onTap;
  final VoidCallback? onCornerIconTap;
  final bool useCustomCornerContainer;
  final IconData? cornerIcon;
  final Color? cornerIconColor;
  final List<ImageProvider>? backgroundImages;

  const CustomAdCardWidget({
    Key? key,
    required this.imageUrl,
    this.statusText,
    this.statusColor,
    required this.title,
    required this.price,
    required this.priceColor,
    required this.category,
    required this.categoryColor,

    required this.dateRange,
    this.showCornerIcon = false,
    this.soldText,
    this.onTap,
    this.onCornerIconTap,
    this.useCustomCornerContainer = false,
    this.cornerIcon,
    this.cornerIconColor,
    this.backgroundImages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0.2,

        color: ThemeHelper.getCardColor(context),
        margin: EdgeInsets.all(0),

        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/icons/hori_line.png',
                      image:
                          backgroundImages != null &&
                                  backgroundImages!.isNotEmpty
                              ? (backgroundImages![0] as NetworkImage).url
                              : '',
                      width: 100.w,
                      height: statusText?.isEmpty ?? true ? 120.h : 140.h,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          child: Image.asset(
                            'assets/icons/hori_line.png',
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 15.w), // Spacer
                // Details Section
                Expanded(
                  flex: 3, // Adjust flex as needed
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status Text
                        if (statusText?.isNotEmpty ?? false)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              statusText!,
                              style: AppTextStyles.bodyText2(
                                context,
                              ).copyWith(color: Colors.white),
                            ),
                          ),
                        SizedBox(height: 6.h),
                        // Title
                        Text(
                          title,
                          style: AppTextStyles.bodyText4Bold(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        // Price
                        Text(
                          price,
                          style: AppTextStyles.headingGreenText(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3.h),
                        // Category
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: categoryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3.h),
                        // Date Range
                        Text(
                          dateRange,
                          style: AppTextStyles.bodyText2(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Corner Icon (Three Dots Menu)
            if (showCornerIcon)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Row(
                  children: [
                    Text(soldText ?? '', style: TextStyle(fontSize: 14.sp)),
                    CornerIconContainer(
                      icon: cornerIcon,
                      iconColor: cornerIconColor,
                      onTap: onCornerIconTap,
                      useCustomContainer: useCustomCornerContainer,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CornerIconContainer extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool useCustomContainer;

  const CornerIconContainer({
    Key? key,
    this.icon,
    this.iconColor,
    this.onTap,
    this.useCustomContainer = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (useCustomContainer) {
      // Custom Container with Icon
      return GestureDetector(
        onTap: onTap, // Handle tap for the corner icon
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 26.w,
            height: 26.h,
            decoration: BoxDecoration(
              color: white,
              shape: BoxShape.circle,
              border: Border.all(
                color: ThemeHelper.getFieldBorderColor(context),
              ),
            ),
            child: Center(
              child: Icon(
                icon ?? Icons.more_vert, // Default icon if none is provided
                color: iconColor ?? ThemeHelper.getBlackWhite(context),
                size: 18.sp,
              ),
            ),
          ),
        ),
      );
    } else {
      // Default Icon
      return GestureDetector(
        onTap: onTap, // Handle tap for the corner icon
        child: Icon(
          icon ?? Icons.more_vert, // Default icon if none is provided
          color: iconColor ?? ThemeHelper.getBlackWhite(context),
          size: 20.sp,
        ),
      );
    }
  }
}
