import 'package:flutter/material.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/provider/attendance_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/color_utils.dart';
import '../../../core/widgets/common_dropdown.dart';
import '../widget/attendance_widget.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider =
      Provider.of<AttendanceProvider>(context, listen: false);
      await provider.initializeTodayAttendance();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      child: Consumer<AttendanceProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: commonText(text: "Attendance", fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorProduct,)),
                      Expanded(
                        child: CommonDropdown(
                          hint: 'Select Date Range',
                          items: [
                            "Today",
                            "Yesterday",
                            "Last 7 Days",
                            "Last 30 Days",
                            "This Month",
                            "Last Month",
                            "Custom Date"
                          ],
                          initialValue: provider.selectedDateRange,
                          onChanged: (value) {
                            provider.handleDateRangeSelection(context, value ?? '');
                          },
                        ),
                      ),
                    ],
                  ),
                 Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsetsGeometry.symmetric(
                        horizontal: 0,
                        vertical: 16,
                      ),
                      itemCount: provider.attendanceGridItems.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 columns
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.2,
                      ),
                      itemBuilder: (context, index) {
                        final item = provider.attendanceGridItems[index];
                        return buildItemView(
                          item: item,

                          context: context,
                        );
                      },
                    ),
                  ),
                ],
              ),
              provider.isLoading?showLoaderList():SizedBox.shrink()
            ],
          );
        },
      ),
    );
  }
}
