import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_listtile.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_button.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        //backgroundColor: AppColor.lightgreyColor,
        appBarHeight: 50.h,
        title: 'Payment Method',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              Text(
                'Select Payment Methods',
                style: AppTextStyles.subHeadingText(context),
              ),
              SizedBox(height: 10.h),
              CustomListTile(
                path: '',
                subtitle: '',
                isMore: true,
                title: 'Credit/Debit Card',
                color: ThemeHelper.getTabbarTextColor(context, false),
                onTap: () {},
                iconColor: iconColor,
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: iconColor,
                  size: 17,
                ),
              ),
              CustomListTile(
                path: '',
                subtitle: '',
                isMore: true,
                title: 'Phone number Verified',
                color: ThemeHelper.getTabbarTextColor(context, false),
                onTap: () {},
                iconColor: iconColor,
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: iconColor,
                  size: 17,
                ),
              ),

              SizedBox(height: 300.h),
              CustomButton(
                txtColor: white,
                bgColor: primary,
                text: 'Post Ad',
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const LoginPage()),
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
