import 'package:flutter/material.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/routes/app_routes.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/data/models/dashboard/leave_model.dart';
import 'package:hrms/main.dart';
import 'package:hrms/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/animated_counter.dart';
import '../../leave_details/LeaveDetailsArgs.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    final items = provider.leaves;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      physics: BouncingScrollPhysics(),
      children: [
        commonText(
          text: "Record Your Attendance",
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        SizedBox(height: 10),

        Container(
          decoration: commonBoxDecoration(
            borderColor: colorProduct.withValues(alpha: 0.3),
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            spacing: 30,
            children: [
              Row(
                children: [
                  _commonTopView(desc: "Days", value: 1),
                  _commonTopView(desc: "Days", value: 0, title: "Late"),
                  _commonTopView(desc: "Days", value: 1, title: "Absent"),
                ],
              ),
              Row(
                children: [
                  _commonTopView(desc: "Days", value: 0, title: "Half Days"),
                  _commonTopView(desc: "hr", value: 1, title: "Worked hours"),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 20),
        commonText(
          text: "My Leaves",
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        SizedBox(height: 10),
        Column(
          spacing: 16,
          children: [
            _buildRow(
              context: context,
              provider: provider,
              first: items[0],
              second: items[1],
            ),
            _buildRow(
              context: context,
              provider: provider,
              first: items[2],
              second: items[3],
            ),

            _buildRow(
              context: context,
              provider: provider,
              first: items[4],
              second: items[5],
            ),
          ],
        ),
      ],
    );
  }

  Widget _commonTopView({String? title, int? value, String? desc}) {
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

  Widget _buildRow({
    double? height,
    required BuildContext context,
    required DashboardProvider provider,
    required LeaveModel first,
    LeaveModel? second,
  }) {
    if (second == null) {
      // Only one item in row
      return Row(
        children: [
          Expanded(
            child: _buildCard(
              context: context,
              provider: provider,
              item: first,
              height: 90,
            ),
          ),
        ],
      );
    }

    return Row(
      spacing: 16,
      children: [
        Expanded(
          child: _buildCard(
            context: context,
            provider: provider,
            item: first,
            height: height,
          ),
        ),
        Expanded(
          child: _buildCard(
            context: context,
            provider: provider,
            item: second,
            height: height,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required BuildContext context,
    double? height,
    required DashboardProvider provider,
    required LeaveModel item,
  }) {
    return commonInkWell(
      onTap: () {
        // Check if it's not "Apply"
        if (!item.title.toString().toLowerCase().contains('apply')) {
          // set the selected filter in provider based on title
          provider.setSelectedLeaveType(item.title ?? '');

          // navigate to Leave Listing Screen
          Navigator.pushNamed(
            context,

            RouteName
                .leaveDetailsScreen, // define this route in app_routes.dart
            arguments: LeaveDetailsArgs(
              title: item.title ?? '',
              color: item.bgColor ?? Colors.green,
            ),
          );
        }

        if (item.title.toString().toLowerCase().contains('apply')) {
          // navigate to Leave Listing Screen
          Navigator.pushNamed(
            context,
            RouteName.addLeaveScreen, // define this route in app_routes.dart
          );
        }
      },
      child: Container(
        height: height ?? 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: item.bgColor?.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: item.bgColor ?? Colors.black, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            commonText(
              textAlign: TextAlign.center,
              text: item.title ?? '',
              fontSize: 14,
              color: Colors.black.withValues(alpha: 0.80),
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 5),
            item.title.toString().toLowerCase().contains('apply')
                ? SizedBox.shrink()
                : AnimatedCounter(
                    leftText: '',
                    rightText: '',
                    endValue: item.count ?? 0,
                    duration: Duration(seconds: 2),
                    style: commonTextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
            /*  if (item.title.toString().toLowerCase().contains('apply'))
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: commonButton(
                  height: 35,
                  width: 100,
                  radius: 10,

                  //colorBorder: item.bgColor,
                  color: Colors.transparent,
                  textColor: item.bgColor,

                  fontSize: 12,

                  text: "Add",
                  onPressed: () {

                    navigatorKey.currentState?.pushNamed(RouteName.addLeaveScreen);
                  },
                ),
              ),*/
          ],
        ),
      ),
    );
  }
}
