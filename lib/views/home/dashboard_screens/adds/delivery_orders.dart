import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/views/home/dashboard_screens/adds/buying_orders.dart';
import 'package:humsaya_app/views/home/dashboard_screens/adds/selling_orders.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_listtile.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';

class DeliveryOrders extends StatefulWidget {
  const DeliveryOrders({super.key});

  @override
  State<DeliveryOrders> createState() => _DeliveryOrdersState();
}

class _DeliveryOrdersState extends State<DeliveryOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarHeight: 45.h,
        title: 'Delivery Orders',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              CustomListTile(
                dataIcon: FontAwesomeIcons.warehouse,
                path: '',
                iconColor: iconColor,
                title: 'Buying Orders',
                subtitle: '',
                color: Theme.of(context).scaffoldBackgroundColor,
                isMore: true,
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: iconColor,
                  size: 17,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BuyingOrders()),
                  );
                },
              ),
              CustomListTile(
                dataIcon: FontAwesomeIcons.moneyBill,
                path: '',
                iconColor: iconColor,
                title: 'Selling Orders',
                subtitle: '',
                color: Theme.of(context).scaffoldBackgroundColor,
                isMore: true,
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: iconColor,
                  size: 17,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SellingOrders()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
