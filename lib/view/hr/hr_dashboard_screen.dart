import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/view/leave/leave_listing_screen.dart';
import 'package:provider/provider.dart';

import '../../core/constants/date_utils.dart';
import '../../core/hive/app_config_cache.dart';
import '../../core/hive/user_model.dart';
import '../../core/widgets/cached_image_widget.dart';
import '../../provider/dashboard_provider.dart';
import '../dashboard/widget/home_widget.dart';

class HrDashboardScreen extends StatefulWidget {
  const HrDashboardScreen({super.key});

  @override
  State<HrDashboardScreen> createState() => _HrDashboardScreenState();
}

class _HrDashboardScreenState extends State<HrDashboardScreen> {
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
      provider.getCurrentMonthIncrementEmp(),
      provider.getHikAttendanceDashboard(),
      provider.getLeaveDataDashboard(),
      provider.getAllUserLeavesBalance(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return commonScaffold(
      appBar: commonAppBar(
        title: "Dashboard",
        context: context,
        centerTitle: true,
      ),
      body: commonRefreshIndicator(
        onRefresh: () async {
          init();
        },
        child: Consumer<DashboardProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: ListView(
                shrinkWrap: true,
                // spacing: 20,
                children: [
                  commonHomeRowView(
                    title: "Dashboard",
                    isHideSeeMore: true,
                    onTap: () {
                      /* navigatorKey.currentState?.pushNamed(
                              RouteName.upcomingBirthdayScreen,
                            );*/
                    },
                  ),

                  SizedBox(height: 8),
                  Consumer<DashboardProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        spacing: 20,
                        children: [
                          Row(
                            spacing: 20,
                            children: [
                              Expanded(
                                child: commonView(
                                  colorBg: Colors.blue,
                                  value:
                                      '${provider.employeeIncrementModel?.activeEmp?.activeCount ?? "0"}',
                                ),
                              ),
                              Expanded(
                                child: commonView(
                                  title: "Today's Leaves",
                                  colorBg: Colors.orange,
                                  value: '${provider.todayLeavesCount}',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 20,
                            children: [
                              Expanded(
                                child: commonView(
                                  title: "External System Access Employees",
                                  colorBg: Colors.green,
                                  value:
                                      '${provider.employeeIncrementModel?.activeEmp?.activeCount ?? "0"}',
                                ),
                              ),
                              Expanded(
                                child: commonView(
                                  title: "Online Employees",
                                  colorBg: Colors.indigo,
                                  value:
                                      '${provider.employeeIncrementModel?.onlineEmployees?.empCount ?? "0"}',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 20,
                            children: [
                              Expanded(
                                child: commonView(
                                  onTap: () {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setStateSheet) {
                                            return Container(
                                              padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context).viewInsets.bottom,
                                                left: 16,
                                                right: 16,
                                                top: 24,
                                              ),
                                              height: size.height * 0.8,
                                              child: Consumer<DashboardProvider>(
                                                builder: (context, provider, child) {
                                                  return Column(
                                                    children: [

                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          commonText(
                                                            text: 'Leave Balance',
                                                            fontWeight: FontWeight.w600,
                                                            color: colorLogo,
                                                            fontSize: 16,
                                                          ),
                                                          commonInkWell(
                                                            onTap: () async {
                                                              Navigator.pop(context);
                                                              await provider.getAllUserLeavesBalance();
                                                  },
                                                            child: Container(
                                                              width: 35,
                                                              height: 35,
                                                              decoration: commonBoxDecoration(
                                                                color: colorLogo,
                                                                shape: BoxShape.circle,
                                                              ),
                                                              child: const Center(
                                                                child: Icon(Icons.close, size: 15, color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      SizedBox(height: 16),

                                                      /// 🔍 SEARCH FIELD
                                                      commonTextField(
                                                        hintText: "Search Employee Name",
                                                        onChanged: (value) async {
                                                          if (value.length > 3) {
                                                            await provider.getAllUserLeavesBalance(search: value);
                                                          } else {
                                                            await provider.getAllUserLeavesBalance();
                                                          }

                                                          // 🔴 This forces the bottom sheet to rebuild instantly
                                                          setStateSheet(() {});
                                                        },
                                                      ),

                                                      SizedBox(height: 8),

                                                      Expanded(
                                                        child: commonEmpLeaveBalance(
                                                          size: size,
                                                          provider: provider,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );

                                    /*    showCommonBottomSheet(
                                      context: context,
                                      content: SizedBox(
                                        height: size.height * 0.8,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                commonText(
                                                  text: 'Leave Balance',
                                                  fontWeight: FontWeight.w600,
                                                  color: colorLogo,
                                                  fontSize: 16,
                                                ),
                                                commonInkWell(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    width: 35,
                                                    height: 35,
                                                    decoration: commonBoxDecoration(
                                                      color: colorLogo,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        size: 15,
                                                        Icons.close,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),


                                            SizedBox(height: 16),

                                            commonTextField(hintText: "Search  Employee Name",
                                            onChanged: (value){
                                              if(value.length>3){
                                                provider.getAllUserLeavesBalance(search: value);
                                              }else
                                                {
                                                  provider.getAllUserLeavesBalance();
                                                }

                                            }),
                                            SizedBox(height: 8),
                                            Expanded(
                                              child: commonEmpLeaveBalance(
                                                size: size,
                                                provider: provider,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );*/
                                  },
                                  title: "View Employees Leave Balance",
                                  colorBg: Colors.green,
                                  value:
                                  '${provider.employeeIncrementModel?.activeEmp?.activeCount ?? "0"}',
                                ),
                              ),
                              Expanded(
                                child: commonView(
                                  onTap: () {
                                    showCommonBottomSheet(
                                      context: context,
                                      content: SizedBox(
                                        height: size.height * 0.8,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                commonText(
                                                  text: 'Leave Request',
                                                  fontWeight: FontWeight.w600,
                                                  color: colorLogo,
                                                  fontSize: 16,
                                                ),
                                                commonInkWell(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    width: 35,
                                                    height: 35,
                                                    decoration: commonBoxDecoration(
                                                      color: colorLogo,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        size: 15,
                                                        Icons.close,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: LeaveListingScreen(
                                                hideAppBar: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  title: "View Leave Request",
                                  colorBg: Colors.indigo,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 20),
                  Consumer<DashboardProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        children: [
                          commonHomeRowView(
                            title: "Today's Attendance",
                            onTap: () {
                              showCommonBottomSheet(
                                context: context,
                                content: SizedBox(
                                  height: size.height * 0.8,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          commonText(
                                            text: 'Attendance List',
                                            fontWeight: FontWeight.w600,
                                            color: colorLogo,
                                            fontSize: 16,
                                          ),
                                          commonInkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              width: 35,
                                              height: 35,
                                              decoration: commonBoxDecoration(
                                                color: colorLogo,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  size: 15,
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Expanded(
                                        child: commonAttendanceView(
                                          size: size,
                                          provider: provider,
                                          scrollDirection: Axis.vertical,
                                          itemCount: provider
                                              .employeeAttendanceModel
                                              .length,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            height: 80,

                            width: size.width,
                            child: commonAttendanceView(
                              size: size,
                              provider: provider,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 20),
                  Consumer<DashboardProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        children: [
                          commonHomeRowView(
                            title: "Upcoming Employees Increments",
                            onTap: () {
                              showCommonBottomSheet(
                                context: context,
                                content: SizedBox(
                                  height: size.height * 0.8,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          commonText(
                                            text: 'Increment List',
                                            fontWeight: FontWeight.w600,
                                            color: colorLogo,
                                            fontSize: 16,
                                          ),
                                          commonInkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              width: 35,
                                              height: 35,
                                              decoration: commonBoxDecoration(
                                                color: colorLogo,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  size: 15,
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Expanded(
                                        child: commonAttendanceView(
                                          size: size,
                                          provider: provider,
                                          scrollDirection: Axis.vertical,
                                          itemCount: provider
                                              .employeeIncrementModel
                                              ?.increments
                                              ?.length,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            height: 80,

                            width: size.width,
                            child: commonIncrementView(
                              provider: provider,
                              size: size,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  //  Expanded(child: LeaveListingScreen( hideAppBar: true,))
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Widget commonView({
    String? title,
    String? value,
    Color? colorBg,
    void Function()? onTap,
  }) {
    return commonInkWell(
      onTap: onTap,
      child: Container(
        height: 130,

        decoration: commonBoxDecoration(
          color:
              colorBg?.withValues(alpha: 0.06) ??
              Colors.red.withValues(alpha: 0.06),
          borderColor: colorBorder,
        ),
        child: Column(
          mainAxisAlignment: .center,

          children: [
            commonText(
              text: title ?? "Total Employees",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textAlign: .center,
            ),
            value?.isNotEmpty == true
                ? commonText(
                    text: value ?? "0",
                    fontSize: 24,
                    fontWeight: .w800,
                    textAlign: .center,
                    color: colorBg,
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget commonAttendanceView({
    required DashboardProvider provider,
    int? itemCount,
    required Size size,
    Axis? scrollDirection,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: scrollDirection ?? Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      //padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16),
      itemCount:
          itemCount ?? min(provider.employeeAttendanceModel.length , 5),
      //itemCount: 5,
      itemBuilder: (context, index) {
        final item = provider.employeeAttendanceModel[index];
        return Container(
          width: size.width * 0.8,
          decoration: commonBoxDecoration(borderColor: colorBorder),
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedImageWidget(
                imageUrl: item.profileImage,

                borderRadius: 500,
                width: 40,
                height: 40,
                fit: BoxFit.cover, // <-- Ensures image fills the height nicely
              ),
            ),
            trailing: commonText(
              text:
                  '${item.officeStartTime ?? ''} AM To ${item.officeEndTime ?? ''} PM',
              fontSize: 10,
            ),
            subtitle: commonText(
              color: Colors.black38,
              text: item.designation ?? '',
              fontSize: 12,
            ),
            title: Column(
              crossAxisAlignment: .start,
              mainAxisSize: MainAxisSize.min,
              children: [
                commonText(
                  text: '${item.firstname ?? ''} ${item.lastname ?? ''}',
                  fontWeight: FontWeight.w600,
                ),
                item.contactNo?.isNotEmpty == true
                    ? commonText(text: item.contactNo ?? '', fontSize: 12)
                    : SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget commonIncrementView({
    required DashboardProvider provider,
    int? itemCount,
    required Size size,
    Axis? scrollDirection,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: scrollDirection ?? Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      //padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16),
      itemCount:
          itemCount ??
          min(provider.employeeIncrementModel?.increments?.length ?? 0, 5),
      //itemCount: 5,
      itemBuilder: (context, index) {
        final item = provider.employeeIncrementModel?.increments?[index];
        return Container(
          width: size.width * 0.8,
          decoration: commonBoxDecoration(borderColor: colorBorder),
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedImageWidget(
                imageUrl: item?.profileImage ?? '',

                borderRadius: 500,
                width: 40,
                height: 40,
                fit: BoxFit.cover, // <-- Ensures image fills the height nicely
              ),
            ),
            /* trailing:   commonText(
              text:
              '${item.officeStartTime ?? ''} AM To ${item.officeEndTime ?? ''} PM',
              fontSize: 10,
            ),*/
            subtitle: commonText(
              color: Colors.black38,
              text: formatDate(
                item?.incrementDate?.date ?? '',
                format: "dd-MM-yyyy",
              ),
              fontSize: 12,
            ),
            title: Column(
              crossAxisAlignment: .start,
              mainAxisSize: MainAxisSize.min,
              children: [
                commonText(
                  text: '${item?.firstname ?? ''} ${item?.lastname ?? ''}',
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget commonEmpLeaveBalance({
    required DashboardProvider provider,
    required Size size,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      //padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16),
      itemCount: provider.employeeLeaveBalanceModel?.data?.length,
      //itemCount: 5,
      itemBuilder: (context, index) {
        final item = provider.employeeLeaveBalanceModel?.data?[index];
        Color color =
        provider.colors[index % provider.colors.length];
        return Container(
          width: size.width * 0.8,
          decoration: commonBoxDecoration(borderColor: colorBorder,
          color: color.withValues(alpha: 0.02)),
          padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
          child: Column(
            children: [
              ListTile(
                //contentPadding: EdgeInsets.zero,

                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedImageWidget(
                    imageUrl: item?.profileImage ?? '',

                    borderRadius: 500,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover, // <-- Ensures image fills the height nicely
                  ),
                ),

                trailing: commonText(text: "Total Leave: ${item?.balance}",fontSize: 12,fontWeight: FontWeight.w600),
                title: commonText(
                  text: '${item?.firstname ?? ''} ${item?.lastname ?? ''}',
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 8,),
              Row(
                spacing: 10,
                children: [
                  Expanded(child: commonLeaveView(color:color,value: item?.cl)),
                  Expanded(child: commonLeaveView(color:color,title: "PL",value: item?.pl)),
                  Expanded(child: commonLeaveView(color:color,title: "SL",value: item?.sl)),
                 // / Expanded(child: commonLeaveView(title: "Total")),
                ],
              )
            ],
          ),
        );
      },
    );
  }
  Widget commonLeaveView({String ? title, dynamic value,required Color color}){
    return Container(
     
      decoration: commonBoxDecoration(
        borderRadius: 4,
        color: color.withValues(alpha: 0.06)
      ),

      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          commonText(text:title?? "CL",fontWeight: FontWeight.w400,textAlign: TextAlign.center,fontSize: 10),
          commonText(text:value??"0.0",fontWeight: FontWeight.w600,textAlign: TextAlign.center,fontSize: 12)
        ],
      ),
    );
  }
}
