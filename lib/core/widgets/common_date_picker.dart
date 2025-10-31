import 'package:flutter/material.dart';
import 'package:hrms/provider/dashboard_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hrms/core/widgets/component.dart';

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
    final provider = Provider.of<DashboardProvider>(context, listen: false);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day); // 🔒 removes past dates

    final picked = await showDatePicker(
      context: context,
      initialDate: isFromField
          ? (provider.fromDate ?? today)
          : (provider.toDate ?? provider.fromDate ?? today),
      firstDate: isFromField
          ? today // 🔒 disable all past dates
          : (provider.fromDate ?? today),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      if (isFromField) {
        provider.setFromDate(picked);
      } else {
        provider.setToDate(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
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
