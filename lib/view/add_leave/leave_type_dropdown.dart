// 🧭 Main widget that handles dropdown + selection
import 'package:flutter/material.dart';

import '../../core/widgets/common_dropdown.dart';
import '../../data/models/leave/leave_model.dart';
import 'leave_dropdown.dart';

class LeaveTypeDropdown extends StatefulWidget {
  final LeaveModel? leaveModel;
  final Function(LeaveTypes selectedType) onLeaveSelected;
  final String? initialCode; // 🟢 add this
  const LeaveTypeDropdown({
    super.key,
    this.initialCode,
    required this.leaveModel,
    required this.onLeaveSelected,
  });

  @override
  State<LeaveTypeDropdown> createState() => _LeaveTypeDropdownState();
}

class _LeaveTypeDropdownState extends State<LeaveTypeDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    _syncInitialSelection();
  }

  @override
  void didUpdateWidget(covariant LeaveTypeDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If leaveModel or initialCode changed, re-sync selection
    if (widget.leaveModel != oldWidget.leaveModel ||
        widget.initialCode != oldWidget.initialCode) {
      _syncInitialSelection();
    }
  }

  void _syncInitialSelection() {
    final items = getLeaveTypeDropdownItems(widget.leaveModel);

    if (items.isEmpty) {
      // nothing to select
      return;
    }

    if (widget.initialCode != null && widget.initialCode!.isNotEmpty) {
      final codeLower = widget.initialCode!.toLowerCase();

      // find match; if not found, fallback to first item
      final matchedItem = items.firstWhere(
            (item) => item.code.toLowerCase() == codeLower,
        orElse: () => items.first,
      );

      setState(() {
        selectedValue = matchedItem.label;
      });

      // Notify parent about the selected LeaveTypes object
      // (do this after the frame so parents/providers are ready)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onLeaveSelected(matchedItem.type);
      });
    } else {
      // no initial code provided -> make sure UI shows provider value if any
      // optional: keep selectedValue unchanged
    }
  }


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
        widget.onLeaveSelected(selectedItem.type);
      },
    );
  }
}
