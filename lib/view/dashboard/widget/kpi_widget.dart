import 'package:flutter/material.dart';
import 'package:hrms/core/constants/image_utils.dart';

import '../../../core/constants/color_utils.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/animated_counter.dart';
import '../../../core/widgets/component.dart';
import '../../../data/models/kpi/kpi_model.dart';
import '../../../provider/kpi_provider.dart';
import '../../leave_details/leave_details_args.dart';
Widget buildMonthCard({
  required KpiModel item,
  required KpiProvider provider,
  required BuildContext context,
}) {
  const List<String> monthNames = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  final int month = item.month ?? 1;
  final int percent = item.percent ?? 0;

  return commonInkWell(
    onTap: () {
      Navigator.pushNamed(
        context,
        RouteName.kpiDetailsScreen,
        arguments: LeaveDetailsArgs(
          title: monthNames[month - 1],
          year: provider.selectedYear,
          color: _getColor(percent),
        ),
      );
    },
    child: Container(
      decoration: commonBoxDecoration(
        color: _getColor(percent).withValues(alpha: 0.05),
        borderColor: colorBorder,
        borderRadius: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            commonAssetImage(
              icMenuCalender,
              width: 32,
              height: 32,
              color: colorProduct.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 10),
            commonText(
              text: monthNames[month - 1],
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorProduct,
            ),
            const SizedBox(height: 6),
            AnimatedCounter(
              leftText: '',
              rightText: '%',
              endValue: percent,
              duration: const Duration(seconds: 2),
              style: commonTextStyle(
                fontSize: 26,
                color: _getColor(percent),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


Widget buildMonthCard1({
  required Map<String, dynamic> item,
  required KpiProvider provider,
  required BuildContext context,
}) {
  return commonInkWell(
    onTap: () {
      Navigator.pushNamed(
        context,

        RouteName.kpiDetailsScreen, // define this route in app_routes.dart
        arguments: LeaveDetailsArgs(
          title: item["month"] ?? '',
          year: provider.selectedYear,
          color: _getColor(item["percent"]),
        ),
      );
    },
    child: Container(
      decoration: commonBoxDecoration(
        color: _getColor(item["percent"]).withValues(alpha: 0.04),
        borderColor: colorBorder,
        borderRadius: 8,
      ),

      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            commonAssetImage(
              icMenuCalender,
              width: 32,
              height: 32,
              color: colorProduct.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 10),
            commonText(
              text: item["month"],
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorProduct,
            ),
            const SizedBox(height: 6),
            AnimatedCounter(
              leftText: '',
              rightText: '%',
              endValue: item["percent"],
              duration: const Duration(seconds: 2),
              style: commonTextStyle(
                fontSize: 26,

                color: _getColor(item["percent"]),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Color _getColor(int percent) {
  if (percent >= 70) return Colors.green;
  if (percent >= 60) return Colors.blue;
  if (percent >= 50) return Colors.orange;
  return Colors.red;
}

void showYearPopover({
  required BuildContext context,
  required KpiProvider provider,
  required GlobalKey buttonKey,
}) async {
  // Get button position
  final RenderBox button =
  buttonKey.currentContext!.findRenderObject() as RenderBox;
  final RenderBox overlay =
  Overlay.of(context).context.findRenderObject() as RenderBox;

  final Offset buttonPosition = button.localToGlobal(
    Offset.zero,
    ancestor: overlay,
  );
  final Size buttonSize = button.size;

  final selected = await showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(
      buttonPosition.dx,
      buttonPosition.dy + buttonSize.height + 4, // pop below button
      overlay.size.width - buttonPosition.dx - buttonSize.width,
      0,
    ),
    items: provider.years.map((year) {
      return PopupMenuItem<String>(
        value: year,
        child: commonText(
          text: year,
          textAlign: TextAlign.center,
          fontSize: 16,
        ),
      );
    }).toList(),
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  if (selected != null && selected != provider.selectedYear) {
    provider.setYear(selected); // ✅ Update Provider
  }
}

