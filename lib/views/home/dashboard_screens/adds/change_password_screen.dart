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

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  bool isOldPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmNewPasswordVisible = false;

  @override
  void dispose() {
    super.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
  }

  Future<void> updatePassword() async {
    if (formKey.currentState!.validate()) {
      if (newPasswordController.text != confirmNewPasswordController.text) {
        cupertinoDialog(context, "New passwords don't match");
        return;
      }
      setState(() {
        isLoading = true;
      });
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      try {
        await authProvider.changeAuthPassword(
          currentPassword: oldPasswordController.text,
          newPassword: newPasswordController.text,
          context: context,
        );
        await authProvider.updateFirestorePassword(
          userId: authProvider.currentUser.uid,
          newPassword: newPasswordController.text,
          context: context,
        );
        Navigator.pop(context);
        Navigator.pop(context);
        cupertinoDialog(context, "Password updated successfully");
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
        trailingIcon: SizedBox(),
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
                          'Change Password',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.authHeadingText(context),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 8.h),
                            CustomTextField(
                              isObscureText: !isOldPasswordVisible,
                              hintText: 'Old Password',
                              controller: oldPasswordController,
                              onChanged: (value) {
                                authProvider.updateCurrentUserFields(
                                  'password',
                                  oldPasswordController.text,
                                );
                              },
                              onTap: () {},
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isOldPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: grey2,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isOldPasswordVisible =
                                        !isOldPasswordVisible;
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
                              isObscureText: !isNewPasswordVisible,
                              hintText: 'New Password',
                              controller: newPasswordController,
                              onTap: () {},
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isNewPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: grey2,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isNewPasswordVisible =
                                        !isNewPasswordVisible;
                                  });
                                },
                              ),
                              validator: (val) {
                                if (val!.trim().isEmpty) {
                                  return 'Confirm Password is required';
                                }
                                if (val != newPasswordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 7.h),
                            CustomTextField(
                              isObscureText: !isConfirmNewPasswordVisible,
                              hintText: 'Confirm New Password',
                              controller: confirmNewPasswordController,
                              onTap: () {},
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isConfirmNewPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: grey2,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isConfirmNewPasswordVisible =
                                        !isConfirmNewPasswordVisible;
                                  });
                                },
                              ),
                              validator: (val) {
                                if (val!.trim().isEmpty) {
                                  return 'Confirm Password is required';
                                }
                                if (val != confirmNewPasswordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 400.h),
                            CustomButton(
                              txtColor: white,
                              bgColor: primary,
                              text: 'Update Password',
                              onTap: () {
                                updatePassword();
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
