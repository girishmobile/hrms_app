import 'package:flutter/material.dart';
import 'package:hrms/core/constants/date_utils.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/main.dart';
import 'package:hrms/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../../core/constants/color_utils.dart';
import '../../core/hive/app_config_cache.dart';
import '../../core/hive/user_model.dart';
import '../../core/widgets/common_date_picker.dart';
import '../../core/widgets/common_dropdown.dart';
import '../../core/widgets/common_switch.dart';
import '../../data/models/leave/LeaveModel.dart';
import '../../provider/leave_provider.dart';
import '../../provider/profile_provider.dart';
import 'LeaveDropdown.dart';
import 'LeaveTypeDropdown.dart';

class AddLeaveScreen extends StatefulWidget {
  const AddLeaveScreen({super.key});

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
    final profile = Provider.of<LeaveProvider>(context, listen: false);

    UserModel? user = await AppConfigCache.getUserModel();

    Map<String, dynamic> body = {
      "emp_id": user?.data?.user?.id,

    };

    print('=====bou$body');


    await profile.getLeaveData(body: body);
  }

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
      appBar: commonAppBar(
        centerTitle: true,
        title: "Add leave",
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
                            text: provider.leaveDays > 0 ? provider.leaveDays.toString() : '',
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
                                    onLeaveSelected: (LeaveTypes selectedType) {
                                      // ✅ You now get full LeaveTypes object here
                                      print("Selected Type: ${selectedType.leavetype}");
                                      print("Full Data: ${selectedType.toJson()}");
                                      provider.setSelectedLeaveType(selectedType);

                                      // Example: send to provider or use in API
                                      // provider.setSelectedLeaveType(selectedType);
                                    },
                                    leaveModel: provider.leaveModel,

                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Column(
                                spacing: 8,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                            ),
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
                        print('==${provider.fromDate!}');

                        UserModel? user = await AppConfigCache.getUserModel();

                        Map<String, dynamic> body = {

                          "user_id":user?.data?.user?.id??0,
                          "leave_date": formatDate('${provider.fromDate??DateTime.now().toString()}',format: "dd-MM-yyyy"),
                          "leave_end_date": formatDate('${provider.toDate??DateTime.now().toString()}',format: "dd-MM-yyyy"),
                          "leave_count": provider.leaveDays,
                          "leave_type": provider.selectedLeaveType?.toJson(), // ✅ This sends full JSON of selected type
                          "half_day": provider.isHalfDay,
                          "half_day_type": null,
                          "reason": provider.tetReason.text,
                        };

                        print('======Boyd$body');
                       // provider.clearLeaveType();
                        provider.addLeaveAPI(body: body);
                        //navigatorKey.currentState?.pop();
                      },
                    ),
                  ],
                ),

                provider.isLoading?showLoaderList():SizedBox.shrink()
              ],
            ),
          );
        },
      ),
    );
  }
}
