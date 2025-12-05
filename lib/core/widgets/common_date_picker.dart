import 'package:flutter/material.dart';
import 'package:hrms/provider/dashboard_provider.dart';
import 'package:hrms/provider/leave_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hrms/core/widgets/component.dart';
import '../../data/models/dashboard/holiday_birthday_model.dart';
import '../constants/image_utils.dart';

class CommonDateField extends StatelessWidget {
  final String text;
  final bool isFromField;

  const CommonDateField({
    super.key,
    required this.text,
    required this.isFromField,
  });

  Future<void> _selectDate(BuildContext context) async {
    final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);
    final dashboardProvider = Provider.of<DashboardProvider>(
      context,
      listen: false,
    );

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // ✅ Get the holidays list from your DashboardProvider (assuming it stores HolidayBirthdayModel)
    final List<Holidays> holidays =
        dashboardProvider.birthdayModel?.holidays ?? [];

    // Convert holiday start_date into DateTime listadd
    final List<DateTime> holidayDates = holidays
        .map((h) => DateTime.parse(h.startDate?.date ?? ''))
        .toList();

    final picked = await showDatePicker(
      context: context,
      initialDate: isFromField
          ? (leaveProvider.fromDate ?? today)
          : (leaveProvider.toDate ?? leaveProvider.fromDate ?? today),
      firstDate: isFromField ? today : (leaveProvider.fromDate ?? today),
      lastDate: DateTime(2100),

      // 🚫 Disable weekends and holidays
      selectableDayPredicate: (DateTime day) {
        // Disable Saturday and Sunday
        if (day.weekday == DateTime.saturday ||
            day.weekday == DateTime.sunday) {
          return false;
        }

        // Disable holidays
        for (final h in holidayDates) {
          if (day.year == h.year && day.month == h.month && day.day == h.day) {
            return false;
          }
        }

        return true; // ✅ Allow other dates
      },
    );

    if (picked != null) {
      if (isFromField) {
        leaveProvider.setFromDate(picked);
      } else {
        leaveProvider.setToDate(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LeaveProvider>(context);
    final dateFormat = DateFormat('dd-MM-yyyy');

    final selectedDate = isFromField ? provider.fromDate : provider.toDate;
    final controller = TextEditingController(
      text: selectedDate != null ? dateFormat.format(selectedDate) : '',
    );

    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: commonTextFieldView(
          text: text,
          maxLines: 1,
          controller: controller,
          readOnly: true,
          keyboardType: TextInputType.none,
          suffixIcon: IconButton(
            icon: commonPrefixIcon(image: icMenuCalender),
            onPressed: () => _selectDate(context),
          ),
        ),
      ),
    );
  }
}
