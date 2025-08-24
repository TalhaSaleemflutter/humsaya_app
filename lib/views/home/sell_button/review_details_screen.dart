import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_action_listtile.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_ad_textfield.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_listtile.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_button.dart';

class ReviewDetailsScreen extends StatefulWidget {
  const ReviewDetailsScreen({super.key});

  @override
  State<ReviewDetailsScreen> createState() => _ReviewDetailsScreenState();
}

class _ReviewDetailsScreenState extends State<ReviewDetailsScreen> {
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        //backgroundColor: AppColor.lightgreyColor,
        appBarHeight: 50.h,
        title: 'Review Details',
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
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 45.h),
              Container(
                height: 100.h, // Adjust size as needed
                width: 100.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeHelper.getCardColor(
                    context,
                  ), // Light gray background
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 50, // Adjust size as needed
                    backgroundColor: Colors.amber, // Background color
                    child: Image.asset(
                      AppAssets.girl,
                      fit: BoxFit.cover,
                      width: 80, // Match with the diameter of the CircleAvatar
                      height: 80,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 50.h),
              CustomAdTextField(
                controller: titleController,
                hintText: "Amna Ali",
                onPrefixIconTap: () {},
                hintTextColor: Theme.of(context).textTheme.bodyLarge?.color,
                // trailing: IconButton(
                //   icon: Icon(color: iconColor, Icons.clear),
                //   onPressed: () {
                //     //  myController.clear();
                //   },
                // ),
              ),

              CustomListTile(
                path: '',
                subtitle: '',
                isMore: true,
                title: 'Phone number Verified',
                color: ThemeHelper.getTabbarTextColor(context, false),
                onTap: () {},
                iconColor: iconColor,
                trailing: Container(
                  height: 30.h,
                  width: 30.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          //isSelected ?
                          primary,
                      // : grey1,
                      width: 2,
                    ),
                    color:
                        //isSelected ?
                        primary,
                    //  :
                    //   Colors.transparent,
                  ),
                  child:
                  // isSelected
                  //     ?
                  Icon(Icons.check, color: white, size: 16.sp),
                  //: null,
                ),
              ),

              CustomActionListTile(
                path: '',
                title: 'Show my phone number in adds',
                subtitle: '',
                color: Theme.of(context).scaffoldBackgroundColor,
                initialToggleValue: true, // Starts as ON
                onTap: (isToggled) {
                  print('Toggled Value: $isToggled');
                  // plannedPaymentProvider
                  //     .updateCurrentPlannedPaymentsField(
                  //   'onDueDate',
                  //   isToggled, // Pass the toggled value
                  //   true,
                  // );
                },
              ),
              SizedBox(height: 300.h),
              CustomButton(
                txtColor: white,
                bgColor: primary,
                text: 'Post Ad',
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const AdDetailScreen(adModel:  ,),
                  //   ),
                  // );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
