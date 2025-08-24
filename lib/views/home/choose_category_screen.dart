import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:humsaya_app/providers/category_provider.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/views/home/dash_board_navigation_page.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class ChooseCategoryScreen extends StatefulWidget {
  const ChooseCategoryScreen({super.key});

  @override
  State<ChooseCategoryScreen> createState() => _ChooseCategoryScreenState();
}

class _ChooseCategoryScreenState extends State<ChooseCategoryScreen> {
    


  Future<bool> _onWillPop() async {
    bool? exitApp = await showCupertinoDialog<bool>(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: Text('Exit'),
            content: Text('Do you want to exit'),
            actions: [
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              CupertinoDialogAction(
                child: Text('Yes'),
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  if (Platform.isAndroid) {
                    SystemNavigator.pop(); // Works on Android
                  } else {
                    exit(0); // Works on iOS
                  }
                },
              ),
            ],
          ),
    );
    return exitApp ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: CustomAppBar(
          appBarHeight: 50.h,
          title: 'Main Category',
          textStyle: AppTextStyles.appBarHeadingText(context),
          trailingIcon: SizedBox(),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 22.w, right: 22.w),
          child: Consumer<CategoryProvider>(
            builder: (BuildContext context, categoryProvider, Widget? child) {
              return Column(
                children: [
                  SizedBox(height: 20.h),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 1,
                      ),
                      itemCount: categoryProvider.categories.length,
                      itemBuilder: (context, index) {
                        final category = categoryProvider.categories[index];
                        return CategoryContainer(
                          title: category.title,
                          icon: category.icon!,
                          iconColor: category.color!,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DashboardNavigationPage(
                                      categoryModel: category,
                                    ),
                              ),
                            );
                            ;
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class CategoryContainer extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const CategoryContainer({
    required this.title,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150.h,
        width: 150.w,
        decoration: BoxDecoration(
          color: ThemeHelper.getCardColor(context),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 32.h),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
