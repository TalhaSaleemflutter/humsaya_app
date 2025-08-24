import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:humsaya_app/providers/auth_provider.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/views/auth/create_account_screen.dart';
import 'package:humsaya_app/views/auth/login_screen.dart';
import 'package:humsaya_app/views/home/choose_category_screen.dart';
import 'package:humsaya_app/widgets/custom_dialogs/custom_cupertino_dialog.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_phone_field.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_textfield.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_auth_button.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_button.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_divider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class LoginWithPhoneScreen extends StatefulWidget {
  const LoginWithPhoneScreen({super.key});
  @override
  State<LoginWithPhoneScreen> createState() => _LoginWithPhoneScreenState();
}

class _LoginWithPhoneScreenState extends State<LoginWithPhoneScreen> {
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  String formattedPhoneNumber = "";

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }

  Future<void> signIn(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      bool hasInternet =
          await InternetConnectionChecker.createInstance().hasConnection;
      if (!hasInternet) {
        cupertinoDialog(context, 'Please connect to the internet to sign in.');
        return;
      }
      if (!isValidPhoneNumber(formattedPhoneNumber)) {
        cupertinoDialog(context, 'Invalid phone number format.');
        setState(() {
          isLoading = false;
        });
        return;
      }
      print('Formatted Phone Number: $formattedPhoneNumber');
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String result = await authProvider.loginWithPhoneNumberAndPassword(
        context: context,
        phoneNo: formattedPhoneNumber,
        password: passwordController.text,
      );

      // if (result == 'Sign in successful') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sign in successful')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChooseCategoryScreen()),
      );
      //}
      // else {

      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('User does not exist. Please sign up first.'),
      //     ),
      //   );
      // }
    } catch (e) {
      cupertinoDialog(context, 'Error: ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool isValidPhoneNumber(String phoneNumber) {
    final regex = RegExp(r'^\+[1-9]\d{1,14}$');
    return regex.hasMatch(phoneNumber);
  }
  //03474149983

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 80.h),
                  Image.asset(AppAssets.appLogo),
                  SizedBox(height: 40.h),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: Text(
                      'Log in to your Hamsaya\naccount',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.authHeadingText(context),
                    ),
                  ),

                  SizedBox(height: 45.h),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        PhoneTextField(
                          controller: phoneController,
                          fillColor: ThemeHelper.getFieldColor(context),
                          hintText: " (xxx) xxx - xxx",
                          onTap: () {
                            print("PhoneTextField tapped!");
                          },
                          onChanged: (value) {
                            formattedPhoneNumber =
                                value; // Store the formatted phone number
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your phone number";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 7.h),
                        CustomTextField(
                          isObscureText: !isPasswordVisible,
                          hintText: 'Password',
                          controller: passwordController,
                          onTap: () {},
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: grey2,
                            ),
                            onPressed: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
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
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Text(
                              'Forgot Password?',
                              textAlign: TextAlign.left,
                              style: AppTextStyles.bodyText2(context).copyWith(
                                color: primary,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25.h),
                        CustomButton(
                          txtColor: white,
                          bgColor: primary,
                          text: 'Log In',
                          onTap: () async {
                            await signIn(context);
                          },
                        ),

                        SizedBox(height: 30.h),
                        Row(
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
                        SizedBox(height: 35.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomAuthButton(
                              icon: CupertinoIcons.at,
                              iconSize: 35,
                              iconColor: ThemeHelper.getBlackWhite(context),
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                            ),
                            CustomAuthButton(
                              svgIcon:
                                  AppAssets
                                      .googleIcon, // Pass only the asset path as a string
                              iconSize: 35,
                              onTap: () {},
                            ),

                            CustomAuthButton(
                              img: AppAssets.icApple,
                              iconColor: ThemeHelper.getBlackWhite(context),
                              onTap: () {},
                            ),
                          ],
                        ),
                        SizedBox(height: 35.h),
                        RichText(
                          text: TextSpan(
                            style: AppTextStyles.bodyText2(context),
                            text: "Don't have an account? ",
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
                                                    const CreateAccountScreen(),
                                          ),
                                        );
                                      },
                                text: "Sign Up",
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
