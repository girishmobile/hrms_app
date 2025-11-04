// 🧭 Main widget that handles dropdown + selection
import 'package:flutter/material.dart';

import '../../core/widgets/common_dropdown.dart';
import '../../data/models/leave/LeaveModel.dart';
import 'LeaveDropdown.dart';

class LeaveTypeDropdown extends StatefulWidget {
  final LeaveModel? leaveModel;
  final Function(LeaveTypes selectedType) onLeaveSelected;

  const LeaveTypeDropdown({
    super.key,
    required this.leaveModel,
    required this.onLeaveSelected,
  });

  @override
  State<LeaveTypeDropdown> createState() => _LeaveTypeDropdownState();
}

class _LeaveTypeDropdownState extends State<LeaveTypeDropdown> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final leaveItems = getLeaveTypeDropdownItems(widget.leaveModel);

    if (leaveItems.isEmpty) {
      return const Text("No leave types available");
    }

    return CommonDropdown(
      hint: 'Select Leave Type',
      items: leaveItems.map((e) => e.label).toList(),
      initialValue: selectedValue,
      onChanged: (value) {
        setState(() => selectedValue = value);

        final selectedItem =
        leaveItems.firstWhere((item) => item.label == value);

        // 🔹 Return the full LeaveTypes object
        widget.onLeaveSelected(selectedItem.type);
      },
    );
  }
}
