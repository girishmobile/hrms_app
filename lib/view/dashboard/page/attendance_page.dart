import 'package:flutter/material.dart';
import 'package:hrms/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../widget/attendance_widget.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsetsGeometry.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          itemCount: provider.attendanceList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final item = provider.attendanceList[index];
            return buildItemView(
              item: item,
              provider: provider,
              context: context,
            );
          },
        );
      },
    );
  }
}
