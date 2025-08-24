import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/providers/auth_provider.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart' as AppPalette;
import 'package:humsaya_app/views/auth/login_screen.dart';
import 'package:humsaya_app/widgets/custom_dialogs/custom_cupertino_dialog.dart';
import 'package:humsaya_app/widgets/custom_listtiles/otp_textfield.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_button.dart';
import 'package:provider/provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool canResend = false;
  int _remainingTime = 60;
  Timer? _timer;
  final FocusNode _otpFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    startTimer();
    // Request focus for OTP field after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_otpFocusNode.canRequestFocus) {
        _otpFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  void startTimer() {
    _timer?.cancel(); // Cancel existing timer if any

    setState(() {
      canResend = false;
      _remainingTime = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          canResend = true;
        });
        timer.cancel();
      }
    });
  }

  Future<void> resendOTP() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });

    try {
      await authProvider.verifyPhoneNumber(
        authProvider.currentUser.phoneNo,
        context,
      );
      startTimer();
      cupertinoDialog(context, 'OTP has been resent successfully');
    } catch (e) {
      cupertinoDialog(context, 'Failed to resend OTP: ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
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
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Consumer<AuthProvider>(
                builder: (context, authProvider, Widget? child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: Text(
                          'OTP Verification',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.authHeadingText(context),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        'Please enter the OTP sent to your registered email/phone number to complete your verification.',
                        style: AppTextStyles.bodyText2(
                          context,
                        ).copyWith(fontSize: 16.sp),
                      ),
                      SizedBox(height: 30.h),
                      Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 15.h),
                            OtpTextField(
                              length: 6,
                              borderColor: Colors.grey,
                              fieldHeight: 40,
                              fieldWidth: 40,
                              fillColor: Colors.white.withOpacity(0.4),
                              filled: true,
                              borderRadius: BorderRadius.circular(8),
                              disabledBorderColor: Colors.grey,
                              focusedBorderColor: AppPalette.primary,
                              textStyle: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              showFieldAsBox: true,
                              onCodeChanged: (String code) {
                                otpController.text = code;
                              },
                              onSubmit: (String verificationCode) {
                                otpController.text = verificationCode;
                              },
                              focusNode: _otpFocusNode,
                              autoFocus: true,
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'Remaining time: ${_remainingTime}s',
                              textAlign: TextAlign.left,
                              style: AppTextStyles.bodyText2(
                                context,
                              ).copyWith(fontSize: 16.sp),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Text(
                                  "Didn't get the code?",
                                  textAlign: TextAlign.left,
                                  style: AppTextStyles.bodyText2(
                                    context,
                                  ).copyWith(fontSize: 16.sp),
                                ),
                                SizedBox(width: 5.w),
                                if (!canResend)
                                  Text(
                                    'Resend (${_remainingTime}s)',
                                    textAlign: TextAlign.left,
                                    style: AppTextStyles.bodyText2(
                                      context,
                                    ).copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                if (canResend)
                                  GestureDetector(
                                    onTap: resendOTP,
                                    child: Text(
                                      'Resend',
                                      textAlign: TextAlign.left,
                                      style: AppTextStyles.bodyText2(
                                        context,
                                      ).copyWith(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppPalette.primary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 370.h),
                            CustomButton(
                              txtColor: AppPalette.white,
                              bgColor: AppPalette.primary,
                              text: 'Verify',
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  bool isOTPVerified = await authProvider
                                      .verifyOTP(otpController.text, context);
                                  print('otp bool is  $isOTPVerified');
                                  if (isOTPVerified) {
                                    try {
                                      print('start calling this function');
                                      await authProvider.signUp(
                                        userModel: authProvider.currentUser,
                                        confirmPassword:
                                            authProvider.currentUser.password,
                                        context: context,
                                      );
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const LoginPage(),
                                        ),
                                      );
                                      cupertinoDialog(
                                        context,
                                        'OTP is verified',
                                      );
                                    } catch (e) {
                                      cupertinoDialog(
                                        context,
                                        "Error creating user: $e",
                                      );
                                    }
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                            ),
                            SizedBox(height: 35.h),
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
