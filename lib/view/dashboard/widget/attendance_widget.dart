import 'package:flutter/material.dart';

import '../../../core/constants/color_utils.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/animated_counter.dart';
import '../../../core/widgets/component.dart';
import '../../../data/models/dashboard/leave_model.dart';
import '../../../provider/dashboard_provider.dart';
import '../../leave_details/leave_details_args.dart';

Widget buildItemView({
  required Map<String, dynamic> item,
 // required DashboardProvider provider,
  required BuildContext context,
}) {
  return commonInkWell(
   /* onTap: () {
      if (!item.title.toString().toLowerCase().contains('apply')) {
        provider.setSelectedLeaveType(item.title ?? '');
        Navigator.pushNamed(
          context,

          RouteName
              .attendanceDetailsScreen, // define this route in app_routes.dart
          arguments: LeaveDetailsArgs(
            title: item.title ?? '',
            color: item.bgColor ?? Colors.green,
          ),
        );
      }
    },*/
    child: Container(
      decoration: commonBoxDecoration(
        borderRadius: 8,
        borderColor: colorBorder,
        //color: item.bgColor?.withValues(alpha: 0.04) ?? Colors.amber,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            commonText(
              text: item['title']??'',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorProduct,
            ),
            const SizedBox(height: 6),
            AnimatedCounter(
              leftText: '',
              rightText:  item['desc'],
              endValue: item['value'],
              duration: Duration(seconds: 2),
              style: commonTextStyle(
                fontSize: 24,
               // color: item.bgColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
