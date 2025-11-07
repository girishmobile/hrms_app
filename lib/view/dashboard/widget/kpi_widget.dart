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
  final Color color = _getMonthColor(month);
  return commonInkWell(
    onTap: () {
      Navigator.pushNamed(
        context,
        RouteName.kpiDetailsScreen,
        arguments: LeaveDetailsArgs(
          title: monthNames[month - 1],
          year: provider.selectedYear,
          color: color,
        ),
      );
    },
    child: Container(
      decoration: commonBoxDecoration(
        color: color.withValues(alpha: 0.03),
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
              userKPI,
              width: 35,
              height: 35,
              color: color.withValues(alpha: 0.8),
            ),
            const SizedBox(height: 10),
            commonText(
              text: monthNames[month - 1],
              fontSize: 16,
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
              color: Colors.black54,
              //  color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}



Color _getMonthColor(int month) {
  switch (month) {
    case 1:
      return Colors.redAccent; // January
    case 2:
      return Colors.pinkAccent; // February
    case 3:
      return Colors.orangeAccent; // March
    case 4:
      return Colors.amber; // April
    case 5:
      return Colors.lightGreen; // May
    case 6:
      return Colors.green; // June
    case 7:
      return Colors.teal; // July
    case 8:
      return Colors.blueAccent; // August
    case 9:
      return Colors.indigoAccent; // September
    case 10:
      return Colors.deepPurpleAccent; // October
    case 11:
      return Colors.purpleAccent; // November
    case 12:
      return Colors.cyan; // December
    default:
      return Colors.grey;
  }
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

