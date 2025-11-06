import 'package:flutter/material.dart';
import 'package:hrms/core/constants/date_utils.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/data/models/leave/all_leave_model.dart';
import 'package:provider/provider.dart';

import '../../core/constants/color_utils.dart';
import '../../core/hive/app_config_cache.dart';
import '../../core/hive/user_model.dart' hide Data;
import '../../core/widgets/common_date_picker.dart';
import '../../core/widgets/common_dropdown.dart';
import '../../core/widgets/common_switch.dart';
import '../../data/models/leave/leave_model.dart';
import '../../provider/leave_provider.dart';
import 'leave_type_dropdown.dart';

class AddLeaveScreen extends StatefulWidget {
  const AddLeaveScreen({super.key, this.data});

  final Data? data;

  @override
  State<AddLeaveScreen> createState() => _AddLeaveScreenState();
}

class _AddLeaveScreenState extends State<AddLeaveScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  Future<void> init() async {
    final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);
    UserModel? user = await AppConfigCache.getUserModel();

    Map<String, dynamic> body = {"emp_id": user?.data?.user?.id};

    await leaveProvider.getLeaveData(body: body);
    if (widget.data != null) {
      final from = widget.data?.leaveDate?.date; // e.g. "2025-11-06"
      final to = widget.data?.leaveEndDate?.date;

      if (from != null && from.isNotEmpty) {
        leaveProvider.setFromDate(DateTime.parse(from));
      }

      if (to != null && to.isNotEmpty) {
        leaveProvider.setToDate(DateTime.parse(to));
      }

      if (widget.data?.reason != null) {
        print('====${widget.data?.reason}');
        setState(() {
          leaveProvider.tetReason.text = widget.data?.reason ?? '';
        });
      }

      print('==${widget.data?.halfDay}');
      leaveProvider.setHalfDay(true);
      leaveProvider.setSelectedHalfType(widget.data?.halfDayType ?? '');
    } else {
      UserModel? user = await AppConfigCache.getUserModel();

      Map<String, dynamic> body = {"emp_id": user?.data?.user?.id};

      await leaveProvider.getLeaveData(body: body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
      appBar: commonAppBar(
        centerTitle: true,
        title: widget.data!=null?"Edit leave":"Add leave",
        context: context,
      ),
      body: Consumer<LeaveProvider>(
        builder: (context, provider, child) {
          return commonPopScope(
            onBack: () {
              provider.clearLeaveType();
            },
            child: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.all(20),

                  children: [
                    Column(
                      spacing: 20,
                      children: [
                        CommonDateField(text: "From", isFromField: true),

                        CommonDateField(text: "To", isFromField: false),
                        commonTextFieldView(
                          text: "Days",
                          readOnly: true,
                          controller: TextEditingController(
                            text: provider.leaveDays == 1 && provider.isHalfDay
                                ? '0.5'
                                : provider.leaveDays.toString(),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 8,
                              child: Column(
                                spacing: 8,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  commonText(text: "Leave Type", fontSize: 13),
                                  LeaveTypeDropdown(
                                    initialCode: widget
                                        .data
                                        ?.leaveType
                                        ?.leavetype, // <- from API
                                    onLeaveSelected: (LeaveTypes selectedType) {
                                      provider.setSelectedLeaveType(
                                        selectedType,
                                      );
                                    },
                                    leaveModel: provider.leaveModel,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Row(
                          spacing: 10,
                          children: [
                            Column(
                              children: [
                                commonText(text: "Half Day", fontSize: 13),
                                CommonSwitch(
                                  value: provider.isHalfDay,
                                  onChanged: (value) =>
                                      provider.setHalfDay(value),
                                  activeThumbColor: colorOffline,
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: Colors.red,
                                ),
                              ],
                            ),
                            if (provider.isHalfDay) ...[
                              Expanded(
                                child: CommonDropdown(
                                  hint: 'Select Leave Type',
                                  items: ["First Half", "Second Half"],
                                  initialValue: provider.selectedHalfType,
                                  onChanged: (value) {
                                    provider.setSelectedHalfType(value ?? '');
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),

                        commonTextFieldView(
                          text: "Reason",
                          maxLines: 5,
                          controller: provider.tetReason,
                          keyboardType: TextInputType.multiline,
                        ),
                      ],
                    ),

                    SizedBox(height: 40),
                    commonButton(
                      text: "Apply",
                      onPressed: () async {
                        if (provider.fromDate == null) {
                          showToast("Please select a start date");
                          return;
                        }

                        if (provider.toDate == null) {
                          showToast("Please select an end date");
                          return;
                        }

                        if (provider.selectedLeaveType == null) {
                          showToast("Please select a leave type");
                          return;
                        }

                        if (provider.tetReason.text.trim().isEmpty) {
                          showToast("Please enter a reason");
                          return;
                        }

                        if (provider.toDate!.isBefore(provider.fromDate!)) {
                          showToast("End date cannot be before start date");
                          return;
                        }

                        UserModel? user = await AppConfigCache.getUserModel();

                        if (widget.data != null) {
                          Map<String, dynamic> body = {
                            "user_id": user?.data?.user?.id ?? 0,
                            "leave_id": widget.data?.id?? 0,
                            "leave_date": formatDate(
                              '${provider.fromDate ?? DateTime.now().toString()}',
                              format: "dd-MM-yyyy",
                            ),
                            "leave_end_date": formatDate(
                              '${provider.toDate ?? DateTime.now().toString()}',
                              format: "dd-MM-yyyy",
                            ),
                            "leave_count": provider.leaveDays,
                            "leave_type": provider.selectedLeaveType?.toJson(),
                            // ✅ This sends full JSON of selected type
                            "half_day": provider.isHalfDay,
                            "half_day_type": provider.selectedHalfType,
                            "reason": provider.tetReason.text,
                          };


                          provider.updateLeaveAPI(body: body);
                        } else {
                          Map<String, dynamic> body = {
                            "user_id": user?.data?.user?.id ?? 0,
                            "leave_date": formatDate(
                              '${provider.fromDate ?? DateTime.now().toString()}',
                              format: "dd-MM-yyyy",
                            ),
                            "leave_end_date": formatDate(
                              '${provider.toDate ?? DateTime.now().toString()}',
                              format: "dd-MM-yyyy",
                            ),
                            "leave_count": provider.leaveDays,
                            "leave_type": provider.selectedLeaveType?.toJson(),
                            // ✅ This sends full JSON of selected type
                            "half_day": provider.isHalfDay,
                            "half_day_type": provider.selectedHalfType,
                            "reason": provider.tetReason.text,
                          };

                          provider.addLeaveAPI(body: body);
                        }
                      },
                    ),
                  ],
                ),

                provider.isLoading ? showLoaderList() : SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
    );
  }
}
