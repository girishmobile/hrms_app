import 'package:flutter/material.dart';
import 'package:hrms/core/constants/image_utils.dart';
import 'package:hrms/data/models/dashboard/leave_model.dart';
import 'package:hrms/provider/dashboard_provider.dart';

import '../../../core/constants/color_utils.dart';
import '../../../core/constants/date_utils.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/animated_counter.dart';
import '../../../core/widgets/component.dart';
import '../../leave_details/leave_details_args.dart';

Widget buildItemView({
  required LeaveModel item,
  required DashboardProvider provider,
  required BuildContext context,
}) {
  return commonInkWell(
    onTap: () {
      if (!item.title.toString().toLowerCase().contains('apply')) {
        provider.setSelectedLeaveType(item.title ?? '');
        Navigator.pushNamed(
          context,

          RouteName.leaveDetailsScreen, // define this route in app_routes.dart
          arguments: LeaveDetailsArgs(
            title: item.title ?? '',
            color: item.bgColor ?? Colors.green,
          ),
        );
      }

      if (item.title.toString().toLowerCase().contains('apply')) {
        Navigator.pushNamed(
          context,
          RouteName.addLeaveScreen, // define this route in app_routes.dart
        );
      }
    },
    child: Container(
      decoration: commonBoxDecoration(
        borderRadius: 8,
        borderColor: colorBorder,
        color: item.bgColor?.withValues(alpha: 0.04) ?? Colors.amber,
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          commonText(
            text: item.title ?? '',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colorProduct,
          ),
          item.title.toString().toLowerCase().contains('apply')
              ? SizedBox()
              : const SizedBox(height: 6),
          item.title.toString().toLowerCase().contains('apply')
              ? SizedBox()
              : AnimatedCounter(
                  leftText: '',
                  rightText: '',
                  endValue: item.count ?? 0,
                  duration: Duration(seconds: 2),
                  style: commonTextStyle(
                    fontSize: 26,
                    color: item.bgColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ],
      ),
    ),
  );
}

Widget buildHolidayItemView({
  required Map<String, dynamic> item,
  required DashboardProvider provider,
double ?verticalPadding,
  required BuildContext context,
}) {
  final Color bgColor = provider.getHolidayBgColor(item['type']);
  return SizedBox(
    width: 300,
    child: commonInkWell(
      onTap: () {},
      child: Container(
        decoration: commonBoxDecoration(
          color: bgColor.withValues(alpha: 0.1),
          borderRadius: 8,
          borderColor: colorBorder
        ),

        child: IntrinsicHeight(
          child: Row(
            spacing: 10,
            children: [
              Container(
                clipBehavior: Clip.none,
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: verticalPadding??0),
                height: double.infinity,

                decoration: BoxDecoration(
                  color: bgColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Column(
                  spacing: 3,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    commonText(
                      fontWeight: FontWeight.w500,
                      text: formatDay(item['date']),
                      fontSize: 12,
                      color: colorText,
                    ),
                    commonText(
                      fontWeight: FontWeight.w600,
                      text: formatWeek(item['date']),
                      fontSize: 14,
                      color: colorProduct,
                    ),
                    commonText(
                      fontWeight: FontWeight.w500,
                      text: formatMonth(item['date']),
                      fontSize: 12,
                      color: colorText,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  spacing: 3,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    commonText(
                      text: item['name'],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorProduct,
                    ),

                    commonText(
                      text: item['type'],
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: colorProduct,
                    ),
                    commonText(
                      text: item['description'],
                      fontSize: 12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w400,
                      color: colorProduct,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget buildBirthdayItemView({
  required Map<String, dynamic> item,
  required DashboardProvider provider,
  double ?verticalPadding,
  required BuildContext context,
}) {
  final bgColor = provider.getBirthdayBgColor(DateTime.parse(item['date']));
  return SizedBox(
    width: 300,
    child: commonInkWell(
      onTap: () {},
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 10,vertical: verticalPadding??0),

        decoration: commonBoxDecoration(
          color: bgColor.withValues(alpha: 0.1),
          borderColor: colorBorder,
          borderRadius: 8
        ),

        child: Row(

          children: [

            Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                commonAssetImage(icDummyUser,width: 50,height: 50),
                Column(
                  spacing: 3,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    commonText(
                      text: item['name'],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorProduct,
                    ),

                    commonText(
                      text: item['department'],
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: colorProduct,
                    ),
                    Row(

                      children: [
                        commonText(
                          fontWeight: FontWeight.w400,
                          text: formatDay(item['date']),
                          fontSize: 12,
                          color: colorText,
                        ),

                        commonText(
                          fontWeight: FontWeight.w400,
                          text: formatMonth(item['date']),
                          fontSize: 12,
                          color: colorText,
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget commonTopView({String? title, int? value, String? desc}) {
  return Expanded(
    child: Column(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonText(
          text: title ?? "Attendance",
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        AnimatedCounter(
          leftText: '',
          rightText: ' $desc',
          endValue: value ?? 0,
          duration: Duration(seconds: 2),
          style: commonTextStyle(
            fontSize: 12,
            color: colorProduct,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
Widget commonHomeRowView({String ? title,bool isHideSeeMore=false,void Function()? onTap}){
  return Row(
    children: [
      Expanded(
        child: commonText(
          text: title??"Upcoming Holidays",
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),

      isHideSeeMore ?SizedBox.shrink(): commonInkWell(
        onTap: onTap,
        child: commonText(
          text: "Sell All",
          color: Colors.grey,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    ],
  );
}