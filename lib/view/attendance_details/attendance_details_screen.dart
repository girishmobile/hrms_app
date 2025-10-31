import 'package:flutter/material.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../../core/constants/date_utils.dart';
import '../../core/widgets/common_date_range_picker.dart';

class AttendanceDetailsScreen extends StatelessWidget {
  final String? title;
  final Color? color;

  const AttendanceDetailsScreen({super.key, this.title, this.color});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    final attendanceList = provider.allAttendanceDetails;

    return commonScaffold(
      appBar: commonAppBar(
        context: context,
        centerTitle: true,
        title: /*title ?? */ 'Attendance',
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child:  Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonInlineRangePicker(
                    onRangeSelected: (range) {
                      debugPrint('From: ${range.start}');
                      debugPrint('To: ${range.end}');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: attendanceList.isEmpty
                  ? Center(child: Text("No ${title ?? ''} available"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(0),

                      shrinkWrap: true,
                      itemCount: attendanceList.length,
                      itemBuilder: (context, index) {
                        final data = attendanceList[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: color ?? colorBorder),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.only(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            top: 0,
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              spacing: 1,
                              children: [
                                fromToView(
                                  date: data['date'],

                                  color: color ?? Colors.red,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 0,
                                      right: 16,
                                      bottom: 16,
                                      top: 16,
                                    ),
                                    color:
                                        color?.withValues(alpha: 0.03) ??
                                        Colors.white,
                                    child: Column(
                                      spacing: 8,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        commonItemView(
                                          title: "Entry Time",
                                          value: data['entryTime'],
                                        ),
                                        commonItemView(
                                          title: "Exit Time",
                                          value: data['exitTime'],
                                        ),

                                        commonItemView(
                                          title: "Working Hours",

                                          value: '${data['workingHours']}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fromToView({String? date, required Color color}) {
    final parts = formatDateSplit(date);
    return Container(
      decoration: commonBoxDecoration(
        color: color.withValues(alpha: 0.04),
        borderRadius: 8,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        spacing: 3,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              commonText(
                color: color,
                text: parts['top'] ?? '',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              commonText(
                color: color,
                text: parts['bottom'] ?? '',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget commonItemView({String? title, String? value, Widget? customView}) {
    return Row(
      children: [
        Expanded(
          child: commonText(
            text: "$title :",
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        Expanded(
          child:
              customView ??
              commonText(
                textAlign: TextAlign.right,
                text: value ?? '',
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
        ),
      ],
    );
  }
}
