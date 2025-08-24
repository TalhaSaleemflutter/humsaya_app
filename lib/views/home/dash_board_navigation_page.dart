import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:humsaya_app/models/ad_product_model.dart';
import 'package:humsaya_app/models/category_model.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/views/home/dashboard_screens/account_screens/account_screen.dart';
import 'package:humsaya_app/views/home/dashboard_screens/adds/my_ads_screen.dart';
import 'package:humsaya_app/views/home/dashboard_screens/adds/sell_screen.dart';
import 'package:humsaya_app/views/home/dashboard_screens/chat/chat_screen.dart';
import 'package:humsaya_app/views/home/dashboard_screens/product_section_screen.dart';

class DashboardNavigationPage extends StatefulWidget {
  const DashboardNavigationPage({super.key, this.categoryModel});
  final CategoryModel? categoryModel;
  @override
  DashboardNavigationPageState createState() => DashboardNavigationPageState();
}

class DashboardNavigationPageState extends State<DashboardNavigationPage> {
  int _selectedIndex = 0;
  

  List<Widget> get _pages => [
    ProductSectionScreen(categoryModel: widget.categoryModel!),
    ChatScreen(
      adModel: AdModel(
        uid: '',
        addId: '',
        title: '',
        description: '',
        price: 0.0,
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
    const SizedBox.shrink(),
    const MyAdsScreen(),
    const AccountScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SellScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // void _onItemTapped(int index) {
  //   if (index == 2) {
  //     // First, add the screen dynamically to the PageView
  //     print('Navigating to PlusbtnBottomSheet');
  //     DynamicSwipeNavigationScreen.globalKey.currentState
  //         ?.addScreen(const PlusbtnBottomSheet());
  //   } else {
  //     setState(() {
  //       _selectedIndex = index;
  //     });
  //   }
  // }

  // void _onItemTapped(int index) {
  //   if (index == 2) {
  //     final transactionProvider =
  //         Provider.of<TransactionProvider>(context, listen: false);
  //     transactionProvider.clearCurrentTransaction(false);
  //     // Bottom sheet handling
  //     showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (_) => const TransactionBottomSheet(),
  //     );
  //   } else {
  //     setState(() {
  //       _selectedIndex = index;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 17.w,
          right: 12.w,
          bottom: Platform.isIOS ? 25.h : 5.h,
          top: 5.h,
        ), // Adjust as needed
        decoration: BoxDecoration(
          color:
              Theme.of(
                context,
              ).scaffoldBackgroundColor, // Matches scaffold background
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home, 'Home', 0),
            _buildNavItem(FontAwesomeIcons.commentDots, 'Chats', 1),
            _buildNavItem(Icons.add_circle, '', 2, isCenter: true),
            _buildNavItem(CupertinoIcons.square_stack, 'Adds', 3),
            _buildNavItem(CupertinoIcons.person, 'Account', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index, {
    bool isCenter = false,
  }) {
    final bool isSelected = _selectedIndex == index;

    return SizedBox(
      width: 71.w,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: isCenter ? 9.h : 0),
              child: Icon(
                icon,
                size:
                    isCenter
                        ? 45.sp
                        : 25.sp, // Larger icon for the center button
                color:
                    (isSelected || isCenter)
                        ? primary
                        : (ThemeHelper.isDarkMode(context) ? white : grey2),
              ),
            ),
            if (!isCenter) ...[
              SizedBox(height: 5.h), // Space between icon and label
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  color:
                      isSelected
                          ? primary
                          : (ThemeHelper.isDarkMode(context) ? white : grey2),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
