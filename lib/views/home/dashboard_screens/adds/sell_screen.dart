import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/providers/ad_provider.dart';
import 'package:humsaya_app/providers/category_provider.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/views/home/sell_button/add_info_screen.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_listtile.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarHeight: 45.h,
        title: 'Sell',
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
        padding: EdgeInsets.only(left: 24.w, right: 24.w),
        child: Consumer2<CategoryProvider, AdProvider>(
          builder: (
            BuildContext context,
            categoryProvider,
            AdProvider,
            Widget? child,
          ) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.h),
                Container(
                  decoration: BoxDecoration(
                    color: ThemeHelper.getCardColor(context),
                    border: Border.all(
                      color: ThemeHelper.getFieldBorderColor(context),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    onTap: () {},
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(
                        Icons.search,
                        color: ThemeHelper.getTabbarTextColor(context, false),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text('Popular', style: AppTextStyles.subHeadingText(context)),
                SizedBox(height: 8.h),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: categoryProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryProvider.categories[index];
                    return CustomListTile(
                      dataIcon: category.icon,
                      path: '',
                      iconColor: white,
                      title: category.title,
                      subtitle: '',
                      color: category.color,
                      isMore: true,
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: iconColor,
                        size: 17,
                      ),
                      onTap: () {
                        AdProvider.updateCurrentAdField(
                          'categoryId',
                          category.categoryId,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddInfoScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
