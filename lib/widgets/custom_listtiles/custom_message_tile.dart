import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart' as AppPalette;
import 'package:humsaya_app/shared/theme/theme_helper.dart';

class CustomMessageTile extends StatelessWidget {
  final dynamic leadingIcon;
  final String name;
  final String title;
  final String description;
  final String time;
  final IconData? trailingIcon1;
  final String? text;
  final VoidCallback? onTap;
  final bool isRead;

  const CustomMessageTile({
    Key? key,
    required this.leadingIcon,
    required this.name,
    required this.title,
    required this.description,
    required this.time,
    this.trailingIcon1,
    this.text,
    this.onTap,
    required this.isRead,
  }) : super(key: key);

  String truncateToWords(String text, {int maxWords = 3}) {
    final words = text.split(' ');
    if (words.length <= maxWords) return text;
    return '${words.take(maxWords).join(' ')}...';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(top: 7.h),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 12.w,
                right: 10.w,
                top: 6.w,
                bottom: 6.h,
              ),
              decoration: BoxDecoration(
                color: ThemeHelper.getCardColor(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildLeadingIcon(),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              name,
                              style: AppTextStyles.bodyText3(
                                context,
                              ).copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              time,
                              style: TextStyle(
                                fontSize: 12,
                                color: ThemeHelper.getTabbarTextColor(
                                  context,
                                  false,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          truncateToWords(title, maxWords: 4),
                          style: AppTextStyles.bodyText2(
                            context,
                          ).copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 11,
                            color: ThemeHelper.getTabbarTextColor(
                              context,
                              false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 10.w,
              top: 35.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (trailingIcon1 != null)
                    Icon(trailingIcon1, size: 18, color: Colors.grey),
                  if (trailingIcon1 != null) SizedBox(height: 8),
                  if (text != null && text!.isNotEmpty)
                    Container(
                      height: 18.h,
                      width: 18.w,
                      decoration: BoxDecoration(
                        color: AppPalette.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        text!,
                        style: TextStyle(fontSize: 10.sp, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    if (leadingIcon == null || leadingIcon.toString().isEmpty) {
      return CircleAvatar(
        radius: 28.r,
        backgroundColor: Colors.grey[200],
        child: FaIcon(
          FontAwesomeIcons.user,
          size: 30.r,
          color: Colors.grey[600],
        ),
      );
    }

    final icon = leadingIcon.toString();

    // Network image
    if (icon.startsWith('http')) {
      return CircleAvatar(
        radius: 28.r,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: icon,
            width: 56.w,
            height: 56.h,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildLoadingIndicator(),
            errorWidget: (context, url, error) => _buildDefaultAvatar(),
          ),
        ),
      );
    }

    // Asset image
    return CircleAvatar(
      radius: 28.r,
      backgroundColor: Colors.transparent,
      child:
          icon.endsWith('.svg')
              ? SvgPicture.asset(icon, width: 36.w, height: 36.h)
              : Image.asset(icon, width: 56.w, height: 56.h, fit: BoxFit.cover),
    );
  }

  // Updated default avatar
  Widget _buildDefaultAvatar() {
    return CircleAvatar(
      radius: 28.r,
      backgroundColor: Colors.grey[200],
      child: FaIcon(FontAwesomeIcons.user, size: 30.r, color: Colors.grey[600]),
    );
  }

  // Keep your existing loading indicator
  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(AppPalette.primary),
      ),
    );
  }
}
