import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:intl/intl.dart';

class CommonInlineRangePicker extends StatefulWidget {
  final Function(DateTimeRange)? onRangeSelected;

  const CommonInlineRangePicker({super.key, this.onRangeSelected});

  @override
  State<CommonInlineRangePicker> createState() => _CommonInlineRangePickerState();
}

class _CommonInlineRangePickerState extends State<CommonInlineRangePicker> {
  List<DateTime?> _rangeDates = [];

  String get formattedRange {
    if (_rangeDates.length < 2 || _rangeDates[0] == null || _rangeDates[1] == null) {
      return "Select Date Range";
    }
    final f = DateFormat('dd-MMM-yyyy');
    return "${f.format(_rangeDates[0]!)} → ${f.format(_rangeDates[1]!)}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            _openInlinePicker(context);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: commonBoxDecoration(
              borderColor: colorProduct,
              borderRadius: 8,
            ),
            child: Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                commonText(text: formattedRange, fontSize: 12,color: colorProduct),
                 Icon(Icons.calendar_month_outlined, size: 20,color: colorProduct.withValues(alpha: 0.6),),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openInlinePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  calendarType: CalendarDatePicker2Type.range,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2035),
                  selectedDayHighlightColor: colorProduct,
                ),
                value: _rangeDates,
                onValueChanged: (dates) {
                  setState(() => _rangeDates = dates);
                },
              ),
              const SizedBox(height: 10),
              commonButton(
                  height: 45,
                  text: "Done", onPressed: (){
                if (_rangeDates.length >= 2 &&
                    _rangeDates[0] != null &&
                    _rangeDates[1] != null) {

                  final range = DateTimeRange(
                    start: _rangeDates[0]!,
                    end: _rangeDates[1]!,
                  );
                  widget.onRangeSelected?.call(range);
                }
                Navigator.pop(context);
              }),

            ],
          ),
        ),
      ),
    );
  }
}
