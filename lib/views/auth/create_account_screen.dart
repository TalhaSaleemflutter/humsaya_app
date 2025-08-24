import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/providers/auth_provider.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/views/auth/location_screen.dart';
import 'package:humsaya_app/views/auth/login_screen.dart';
import 'package:humsaya_app/widgets/custom_dialogs/custom_cupertino_dialog.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_phone_field.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_textfield.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_auth_button.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_button.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_divider.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_dropdown.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});
  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? selectedGender;

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;
  String formattedPhoneNumber = "";
  bool isChecked = false;

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();
  }

  void signUp() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (formKey.currentState!.validate()) {
      if (!isValidPhoneNumber(formattedPhoneNumber)) {
        cupertinoDialog(context, 'Invalid phone number format.');
        setState(() {
          isLoading = false;
        });
        return;
      }
      print(authProvider.currentUser.toMap());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LocationScreen()),
      );
    }
  }

  bool isValidPhoneNumber(String phoneNumber) {
    final regex = RegExp(r'^\+[1-9]\d{1,14}$');
    return regex.hasMatch(phoneNumber);
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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Consumer<AuthProvider>(
                builder: (BuildContext context, authProvider, Widget? child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10.w,
                          right: 10.w,
                          top: 10.h,
                        ),
                        child: Text(
                          'Create new account',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.authHeadingText(context),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              hintText: 'Name',
                              controller: nameController,
                              onChanged: (value) {
                                authProvider.updateCurrentUserFields(
                                  'name',
                                  nameController.text = value,
                                );
                              },
                              onTap: () {},
                            ),
                            SizedBox(height: 8.h),
                            CustomTextField(
                              hintText: 'Email or Username',
                              controller: emailController,
                              onChanged: (value) {
                                authProvider.updateCurrentUserFields(
                                  'email',
                                  emailController.text,
                                );
                              },
                              onTap: () {},
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return 'Email is required';
                                }
                                final emailRegex = RegExp(
                                  r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                                );
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 7.h),
                            CustomDropdownWidget(
                              hintText:
                                  selectedGender ??
                                  authProvider.currentUser.gender.toString(),
                              height: 60.h,
                              color: ThemeHelper.getFieldColor(context),
                              initialValue:
                                  selectedGender ??
                                  authProvider.currentUser.gender,
                              itemLabel: (item) => item,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                });
                                authProvider.updateCurrentUserFields(
                                  'gender',
                                  value,
                                );
                              },
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return "Please enter gender";
                              //   }
                              //   return null;
                              // },
                              items: const ['Male', 'Female'],
                            ),
                            SizedBox(height: 9.h),
                            PhoneTextField(
                              controller: phoneController,
                              fillColor: ThemeHelper.getFieldColor(context),
                              hintText: " (xxx) xxx - xxx",
                              onTap: () {
                                print("PhoneTextField tapped!");
                              },
                              onChanged: (value) {
                                authProvider.updateCurrentUserFields(
                                  'phoneNo',
                                  formattedPhoneNumber = value,
                                );
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your phone number";
                                }
                                return null;
                              },
                            ),

                            CustomTextField(
                              isObscureText: !isPasswordVisible,
                              hintText: 'Password',
                              controller: passwordController,
                              onChanged: (value) {
                                authProvider.updateCurrentUserFields(
                                  'password',
                                  passwordController.text,
                                );
                              },
                              onTap: () {},
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: grey2,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                              validator: (val) {
                                if (val!.trim().isEmpty) {
                                  return 'Password is required';
                                }
                                if (val.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 7.h),
                            CustomTextField(
                              isObscureText: !isConfirmPasswordVisible,
                              hintText: 'Confirm Password',
                              controller: confirmPasswordController,
                              onTap: () {},
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isConfirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: grey2,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isConfirmPasswordVisible =
                                        !isConfirmPasswordVisible;
                                  });
                                },
                              ),
                              validator: (val) {
                                if (val!.trim().isEmpty) {
                                  return 'Confirm Password is required';
                                }
                                if (val != passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  },
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  activeColor: Colors.green,
                                  checkColor: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: ThemeHelper.getBlackWhite(
                                          context,
                                        ),
                                        fontSize: 15.sp,
                                      ),
                                      children: [
                                        const TextSpan(text: "I agree to the "),
                                        TextSpan(
                                          text: "Terms & Conditions",
                                          style: const TextStyle(
                                            color: primary,
                                          ),
                                        ),
                                        const TextSpan(text: " and "),
                                        TextSpan(
                                          text: "Privacy policy",
                                          style: const TextStyle(
                                            color: primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.h),
                            CustomButton(
                              txtColor: white,
                              bgColor: primary,
                              text: 'Next',
                              onTap: () {
                                signUp();
                              },
                            ),
                            SizedBox(height: 18.h),
                            Padding(
                              padding: EdgeInsets.only(left: 20.w, right: 20.w),
                              child: Row(
                                children: [
                                  const Expanded(child: CustomDivider()),
                                  SizedBox(width: 11.w),
                                  Text(
                                    'or sign up with',
                                    style: AppTextStyles.bodyText2(context),
                                  ),
                                  SizedBox(width: 11.w),
                                  const Expanded(child: CustomDivider()),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomAuthButton(
                                  svgIcon: AppAssets.googleIcon,
                                  iconSize: 35,
                                  onTap: () {},
                                ),
                                CustomAuthButton(
                                  img: AppAssets.icApple,
                                  iconColor: ThemeHelper.getBlackWhite(context),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LocationScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 18.h),
                            RichText(
                              text: TextSpan(
                                style: AppTextStyles.bodyText3(context),
                                text: "Already have an account? ",
                                children: [
                                  TextSpan(
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        const LoginPage(),
                                              ),
                                            );
                                          },
                                    text: "Sign In",
                                    style: AppTextStyles.bodyText2(
                                      context,
                                    ).copyWith(color: primary),
                                  ),
                                ],
                              ),
                            ),
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
