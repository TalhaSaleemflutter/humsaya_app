import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/models/user_model.dart';
import 'package:humsaya_app/providers/auth_provider.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/views/auth/otp_verification_screen.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_textfield.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_button.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  final List items;
  AddressScreen({super.key, required this.items});
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool isLoading = false;
  final streetNumberController = TextEditingController();
  final houseAddressController = TextEditingController();
  final cityNameController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();
  final countryNameController = TextEditingController();
  final locationController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late final UserModel? userModel;

  @override
  void dispose() {
    super.dispose();
    houseAddressController.dispose();
    streetNumberController.dispose();
    cityNameController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    countryNameController.dispose();
    locationController.dispose();
  }

  void sentOtp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authProvider.verifyPhoneNumber(
        authProvider.currentUser.phoneNo,
        context,
      );

      setState(() {
        isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtpVerificationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarHeight: 30.h,
        title: '',
        textStyle: const TextStyle(fontSize: 20),
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
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Consumer<AuthProvider>(
                builder: (BuildContext context, authProvider, Widget? child) {
                  return Column(
                    children: [
                      Text(
                        "Address Screen",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.authHeadingText(context),
                      ),
                      SizedBox(height: 30.h),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              readOnly: true,
                              hintText:
                                  widget.items.isNotEmpty
                                      ? widget.items.first.toString()
                                      : 'No item selected',
                              controller: locationController,
                              onChanged: (value) {
                                authProvider.updateCurrentLocationField(
                                  'location.neighborLocation',
                                  locationController.text,
                                );
                              },
                              onTap: () {},
                            ),
                            SizedBox(height: 10.h),
                            CustomTextField(
                              hintText: 'Street number',
                              controller: streetNumberController,
                              onChanged: (value) {
                                authProvider.updateCurrentLocationField(
                                  'location.streetNumber',
                                  streetNumberController.text,
                                );
                              },
                              onTap: () {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter Street Number";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10.h),
                            CustomTextField(
                              hintText: 'House address',
                              controller: houseAddressController,
                              onChanged: (value) {
                                authProvider.updateCurrentLocationField(
                                  'location.houseAddress',
                                  houseAddressController.text,
                                );
                              },
                              onTap: () {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter house Address";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10.h),
                            CustomTextField(
                              hintText: 'City name',
                              controller: cityNameController,
                              onChanged: (value) {
                                authProvider.updateCurrentLocationField(
                                  'location.city',
                                  cityNameController.text,
                                );
                              },
                              onTap: () {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter city name";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10.h),
                            CustomTextField(
                              hintText: 'State',
                              controller: stateController,
                              onChanged: (value) {
                                authProvider.updateCurrentLocationField(
                                  'location.state',
                                  stateController.text,
                                );
                              },
                              onTap: () {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter State name";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10.h),
                            CustomTextField(
                              hintText: 'Zip code',
                              controller: zipCodeController,
                              onChanged: (value) {
                                authProvider.updateCurrentLocationField(
                                  'location.zipCode',
                                  zipCodeController.text,
                                );
                              },
                              onTap: () {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter zip code";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10.h),
                            CustomTextField(
                              hintText: 'Country name',
                              controller: countryNameController,
                              onChanged: (value) {
                                authProvider.updateCurrentLocationField(
                                  'location.country',
                                  countryNameController.text,
                                );
                              },
                              onTap: () {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter country name";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 130.h),
                            CustomButton(
                              txtColor: white,
                              bgColor: primary,
                              text: 'Next',
                              onTap: () {
                                sentOtp();
                                print(
                                  'user data : $authProvider.currentUser.toMap()',
                                );
                              },
                            ),
                            SizedBox(height: 25.h),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.transparent,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
