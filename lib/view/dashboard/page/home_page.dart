import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hrms/components/components.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/constants/image_utils.dart';
import 'package:hrms/core/routes/app_routes.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/main.dart';
import 'package:hrms/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/hive/app_config_cache.dart';
import '../../../core/hive/user_model.dart';
import '../widget/home_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  UserModel? user;
  Future<void> init() async {
    user = await AppConfigCache.getUserModel();

    // 2. Then update UI synchronously
    setState(() {});

    final provider = Provider.of<DashboardProvider>(context, listen: false);
    await Future.wait([
      provider.getBirthdayHoliday(),
      provider.getCurrentAttendanceRecord(),
      provider.getLeaveCountData(),
      provider.updateFCMToken(),
      provider.getLeaveEmployeeCount(id: user?.data?.user?.id ?? 0),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return commonRefreshIndicator(
          onRefresh: () async {
            init();
          },
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                physics: const BouncingScrollPhysics(),
                children: [
                  user?.data?.user?.role?.name.toString().toLowerCase() == "hr"
                      ? Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: commonInkWell(
                                onTap: () {
                                  navigatorKey.currentState?.pushNamed(
                                    RouteName.hrDashboardScreen,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  spacing: 8,
                                  children: [
                                    Text("HR only see"),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: commonBoxDecoration(
                                        borderRadius: 4,
                                        color: colorProduct,
                                        borderColor: colorProduct,
                                      ),
                                      child: commonText(
                                        text: "View Leave Request",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                          ],
                        )
                      : SizedBox.shrink(),
                  commonHomeRowView(title: "Leave", isHideSeeMore: true),

                  const SizedBox(height: 10),

                  Container(
                    decoration: commonBoxDecoration(
                      borderColor: colorProduct.withValues(alpha: 0.3),
                    ),

                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: .start,
                        crossAxisAlignment: .start,
                        spacing: 0,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 12,
                              ),
                              child: Row(
                                spacing: 0,
                                crossAxisAlignment: .center,
                                mainAxisAlignment: .center,
                                children: [
                                  commonTopView(
                                    crossAxisAlignment: .center,
                                    colorTitle: colorProduct,
                                    title: "Approved Leaves",
                                    desc: "",
                                    value:
                                        provider
                                            .employeeLeaveCountModel
                                            ?.totalLeaves ??
                                        "0",
                                  ),
                                ],
                              ),
                            ),
                          ),

                          VerticalDivider(color: Colors.grey),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 12,
                              ),
                              child: Column(
                                mainAxisAlignment: .center,
                                crossAxisAlignment: .start,
                                children: [
                                  commonText(
                                    text: "Remaining Leaves",
                                    fontWeight: FontWeight.w600,
                                    color: colorLogo,
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    spacing: 0,
                                    crossAxisAlignment: .center,
                                    mainAxisAlignment: .spaceBetween,
                                    children: [
                                      commonTopView(
                                        title: "CL",
                                        desc: "",
                                        value:
                                            provider.employeeLeaveCountModel?.cl
                                                .toString() ??
                                            "0",
                                      ),
                                      commonTopView(
                                        desc: "",
                                        value:
                                            provider.employeeLeaveCountModel?.pl
                                                .toString() ??
                                            "0",
                                        title: "PL",
                                      ),
                                      commonTopView(
                                        desc: "",
                                        value:
                                            provider.employeeLeaveCountModel?.sl
                                                .toString() ??
                                            "0",
                                        title: "SL",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  commonHomeRowView(
                    title: "Record Your Attendance",
                    isHideSeeMore: true,
                  ),

                  const SizedBox(height: 10),

                  Container(
                    decoration: commonBoxDecoration(
                      borderColor: colorProduct.withValues(alpha: 0.3),
                      color: colorProduct.withValues(alpha: 0.03),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      spacing: 30,
                      children: [
                        Row(
                          children: [
                            commonTopView(
                              desc: "Days",
                              value:
                                  provider
                                      .currentAttendanceModel
                                      ?.presentDays ??
                                  0,
                            ),
                            commonTopView(
                              desc: "Days",
                              value:
                                  provider.currentAttendanceModel?.lateDays ??
                                  0,
                              title: "Late",
                            ),
                            commonTopView(
                              desc: "Days",
                              value:
                                  provider.currentAttendanceModel?.absentDays ??
                                  0,
                              title: "Absent",
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            commonTopView(
                              desc: "Days",
                              value:
                                  provider.currentAttendanceModel?.halfDays ??
                                  0,
                              title: "Half Days",
                            ),
                            commonTopView(
                              desc: "hr",

                              value:
                                  provider
                                      .currentAttendanceModel
                                      ?.empStaffing
                                      ?.minutes ??
                                  0,
                              title: "Worked hours",
                            ),
                            Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  commonHomeRowView(title: "My Leaves", isHideSeeMore: true),

                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: 0,
                      right: 0,
                      bottom: 16,
                    ),
                    itemCount: provider.leaveCountData.length + 1,

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 columns
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.2,
                        ),
                    itemBuilder: (context, index) {
                      if (index == provider.leaveCountData.length) {
                        return GestureDetector(
                          onTap: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              RouteName
                                  .addLeaveScreen, // define this route in app_routes.dart
                            );
                            // If add leave screen returned success → refresh page
                            if (result == true) {
                              provider.getLeaveCountData();
                            }
                          },
                          child: Container(
                            decoration: commonBoxDecoration(
                              borderRadius: 8,
                              borderColor: colorBorder,
                              color: Colors.indigo.withValues(alpha: 0.06),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  commonAssetImage(
                                    color: Colors.indigo,
                                    icAdd,
                                    height: 30,
                                    width: 30,
                                  ),
                                  /*  Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.blueAccent,
                                    size: 36,
                                  ),*/
                                  SizedBox(height: 8),
                                  commonText(
                                    text: "Apply Leave",
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      final item = provider.leaveCountData[index];
                      final color = getStatusColor(item.title.toString());
                      return buildItemView(
                        item: item,
                        color: color,
                        provider: provider,
                        context: context,
                      );
                    },
                  ),

                  commonHomeRowView(
                    onTap: () {
                      navigatorKey.currentState?.pushNamed(
                        RouteName.holidayScreen,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 130,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: 0,
                        right: 0,
                        bottom: 16,
                      ),
                      itemCount: min(
                        provider.birthdayModel?.holidays?.length ?? 0,
                        5,
                      ),
                      itemBuilder: (context, index) {
                        final item = provider.birthdayModel?.holidays?[index];
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: buildHolidayItemView(
                            item: item,
                            provider: provider,
                            context: context,
                          ),
                        );
                      },
                    ),
                  ),
                  commonHomeRowView(
                    title: "Upcoming Birthday",
                    onTap: () {
                      navigatorKey.currentState?.pushNamed(
                        RouteName.upcomingBirthdayScreen,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      //padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16),
                      itemCount: min(
                        provider.birthdayModel?.birthdays?.length ?? 0,
                        5,
                      ),
                      itemBuilder: (context, index) {
                        final item = provider.birthdayModel?.birthdays?[index];
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: buildBirthdayItemView(
                            item: item,
                            provider: provider,
                            context: context,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              provider.isLoading ? showLoaderList() : SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }
}
