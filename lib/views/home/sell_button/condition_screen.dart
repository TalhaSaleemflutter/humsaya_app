import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/providers/ad_provider.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_listtile.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class ConditionScreen extends StatefulWidget {
  const ConditionScreen({super.key});

  @override
  State<ConditionScreen> createState() => _ConditionScreenState();
}

class _ConditionScreenState extends State<ConditionScreen> {
  void adjustPaymentType(String type) {
    final addProductProvider = Provider.of<AdProvider>(context, listen: false);
    addProductProvider.updateCurrentAdField('condition', type);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarHeight: 30.h,
        title: 'Condition',
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
        padding: EdgeInsets.only(left: 24.w, right: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.h),
            Text(
              'Choose Condition',
              style: AppTextStyles.subHeadingText(context),
            ),
            SizedBox(height: 8.h),
            CustomListTile(
              path: '',
              iconColor: iconColor,
              title: 'New',
              subtitle: '',
              onTap: () {
                adjustPaymentType('New');
              },
              color: Theme.of(context).scaffoldBackgroundColor,
              isMore: true,
              trailing: Icon(Icons.check, color: primary, size: 25),
            ),
            CustomListTile(
              path: '',
              iconColor: iconColor,
              title: 'Used',
              subtitle: '',
              onTap: () {
                adjustPaymentType('Used');
              },
              color: Theme.of(context).scaffoldBackgroundColor,
              isMore: true,
              trailing: Icon(Icons.check, color: primary, size: 25),
            ),
          ],
        ),
      ),
    );
  }
}
