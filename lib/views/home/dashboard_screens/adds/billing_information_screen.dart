import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_ad_textfield.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_phone_field.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_button.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_dropdown.dart';

class BillingInformationScreen extends StatefulWidget {
  const BillingInformationScreen({super.key});

  @override
  State<BillingInformationScreen> createState() =>
      _BillingInformationScreenState();
}

class _BillingInformationScreenState extends State<BillingInformationScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final bussinessController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final cityAddressController = TextEditingController();
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        //backgroundColor: AppColor.lightgreyColor,
        appBarHeight: 45.h,
        title: 'Billing Information',
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
                'Customer Information',
                style: AppTextStyles.subHeadingText(context),
              ),
              SizedBox(height: 10.h),
              CustomDropdownWidget(
                
                hintText: 'Select Gender',
                height: 56.h,
                initialValue: selectedGender,
                itemLabel: (item) => item,
                onChanged: (value) {},
                items: const ['Male', 'Female'],
              ),
              SizedBox(height: 8.h),
              CustomAdTextField(
                controller: emailController,
                hintText: "Email",
                onPrefixIconTap: () {},
                hintTextColor: Theme.of(context).textTheme.bodyLarge?.color,
              ),

              CustomAdTextField(
                controller: nameController,
                hintText: "Customer name",
                onPrefixIconTap: () {},
                hintTextColor: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              CustomAdTextField(
                controller: bussinessController,
                hintText: "Bussiness name",
                onPrefixIconTap: () {},
                hintTextColor: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              PhoneTextField(
                height: 56.h,
                fillColor: ThemeHelper.getCardColor(context),
                controller: phoneController,
                hintText: " +34 (xxx) xxx - xxx", // Optional, defaults to this
                onTap: () {
                  print("PhoneTextField tapped!");
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your phone number";
                  }
                  return null;
                },
              ),

              SizedBox(height: 30.h),
              Text(
                'Customer Address',
                style: AppTextStyles.subHeadingText(context),
              ),
              SizedBox(height: 10.h),
              CustomAdTextField(
                controller: addressController,
                hintText: "Enter Address",
                onPrefixIconTap: () {},
                hintTextColor: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              CustomAdTextField(
                controller: cityAddressController,
                hintText: "Enter City",
                onPrefixIconTap: () {},
                hintTextColor: Theme.of(context).textTheme.bodyLarge?.color,
              ),

              SizedBox(height: 100.h),
              CustomButton(
                txtColor: white,
                bgColor: primary,
                text: 'Save',
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
