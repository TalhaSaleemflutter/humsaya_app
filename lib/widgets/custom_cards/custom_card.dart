import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';

class CustomProductCard extends StatelessWidget {
  final Widget image;
  final String? price; // Made nullable
  final String? title; // Made nullable
  final String? description; // Made nullable
  final String? time; // Made nullable
  final String? offerText; // Made nullable
  final Color? offerBgColor; // Made nullable
  final String? statusText; // Made nullable
  final VoidCallback? onTap; // onTap is already optional
  final List<ImageProvider>? backgroundImages;

  const CustomProductCard({
    Key? key,
    required this.image,
    this.price,
    this.statusText,
    this.title,
    this.description,
    this.time,
    this.offerText,
    this.offerBgColor,
    this.onTap,
    this.backgroundImages,
  }) : super(key: key);

  String calculateDateDifference(String? createdAt) {
    if (createdAt == null) return 'N/A';
    try {
    
      DateTime createdDate = DateTime.parse(createdAt);
      DateTime today = DateTime.now();
      Duration difference = today.difference(createdDate);

      if (difference.inDays > 365) {
        int years = (difference.inDays / 365).floor();
        return '$years year${years > 1 ? 's' : ''} ago';
      } else if (difference.inDays > 30) {
        int months = (difference.inDays / 30).floor();
        return '$months month${months > 1 ? 's' : ''} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Invalid date'; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 162.w,

        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: ThemeHelper.getCardColor(context),
          elevation: 0.3,
          margin: EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 1 / 0.8,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/icons/hori_line.png',
                    image:
                        backgroundImages?.isNotEmpty ?? false
                            ? (backgroundImages![0] as NetworkImage).url
                            : '',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 9.w, top: 15.w, right: 9.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          price != null ? 'Rs $price' : 'Price not available',
                          style: AppTextStyles.bodyText3(
                            context,
                          ).copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        if (offerText != null && offerText != '0.0')
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: offerBgColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              offerText!,
                              style: const TextStyle(
                                fontSize: 8,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title ?? 'No title', 
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description ??
                          'No description',
                      style: AppTextStyles.bodyText1(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      calculateDateDifference(time), 
                      style: AppTextStyles.bodyText1(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
