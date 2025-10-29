import 'package:flutter/material.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/main.dart';
import 'package:hrms/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../../core/constants/color_utils.dart';
import '../../core/constants/image_utils.dart';
import '../../core/widgets/common_date_range_picker.dart';
import '../../core/widgets/common_dropdown.dart';
import '../../core/widgets/common_switch.dart';

class AddLeaveScreen extends StatelessWidget {
  const AddLeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
      appBar: commonAppBar(
        centerTitle: true,
        title: "Add leave",
        context: context,
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          return commonPopScope(
            onBack: ()
            {
              provider.clearLeaveType();
            },
            child: ListView(
              padding: EdgeInsets.all(20),

              children: [
                Column(
                  spacing: 20,
                  children: [
                   /* commonTextFieldView(
                      text: "From",

                      keyboardType: TextInputType.emailAddress,
                      suffixIcon: commonPrefixIcon(image: icMenuCalender),
                    ),
                    commonTextFieldView(
                      text: "To",
                      keyboardType: TextInputType.emailAddress,
                      suffixIcon: commonPrefixIcon(image: icMenuCalender),
                    ),*/
                    CommonDateField(
                      text: "From",
                      isFromField: true,
                    ),

                    CommonDateField(
                      text: "To",
                      isFromField: false,
                    ),
                    commonTextFieldView(
                      text: "Days",
                      keyboardType: TextInputType.emailAddress,

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
                              commonText(text:"Leave Type", fontSize: 13),
                              CommonDropdown(
                                hint: 'Select Leave Type', // 👈 hint added here
                                // initialValue: provider.leaveType,
                                items: ["CL-7.50 Left", "UPL"],

                                onChanged: (value) {
                                  provider.setLeaveType(value!);
                                },
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
                              commonText(text:"Half Day", fontSize: 13),
                              CommonSwitch(
                                value: provider.isHalfDay,
                                onChanged: (value) => provider.setHalfDay(value),
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
                      keyboardType: TextInputType.emailAddress,

                    ),



                  ],
                ),

                SizedBox(height: 40,),
                commonButton(text: "Apply", onPressed: (){
                  provider.clearLeaveType();
                  navigatorKey.currentState?.pop();
                })



              ],
            ),
          );
        },
      ),
    );
  }
}
