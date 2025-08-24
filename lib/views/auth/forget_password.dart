import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/providers/auth_provider.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/widgets/custom_dialogs/custom_cupertino_dialog.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_textfield.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_button.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final emailController = TextEditingController();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  Future<void> resetPassword() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      try {
        await authProvider.sendPasswordResetEmail(
          email: emailController.text.trim(),
          context: context,
        );
        cupertinoDialog(
          context,
          "Password reset email sent successfully. Please check your email.",
        );
        Navigator.pop(context);
      } catch (e) {
      } finally {
        setState(() {
          isLoading = false;
        });
      }
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
        trailingIcon: const SizedBox(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Stack(
          children: [
            Consumer<AuthProvider>(
              builder: (BuildContext context, authProvider, Widget? child) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10.w,
                          right: 10.w,
                          top: 10.h,
                        ),
                        child: Text(
                          'Forgot Password',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.authHeadingText(context),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Text(
                          'Enter your email address and we will send you a link to reset your password',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyText1(context),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 8.h),
                            CustomTextField(
                              hintText: 'Email Address',
                              controller: emailController,
                              onChanged: (value) {},
                              onTap: () {},
                              validator: (val) {
                                if (val!.trim().isEmpty) {
                                  return 'Email is required';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(val.trim())) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 500.h),
                            CustomButton(
                              txtColor: white,
                              bgColor: primary,
                              text: 'Send Reset Link',
                              onTap: () {
                                resetPassword();
                              },
                            ),
                            SizedBox(height: 18.h),
                          ],
                        ),
                      ),
                    ],
                  ),
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
    );
  }
}
