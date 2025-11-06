import '../../data/models/leave/leave_model.dart';

class LeaveDropdownItem {
  final String code;
  final String label;
  final LeaveTypes type; // full leave type object

  LeaveDropdownItem({
    required this.code,
    required this.label,
    required this.type,
  });
}

// 🧮 Function: Build dropdown items from LeaveModel
List<LeaveDropdownItem> getLeaveTypeDropdownItems(LeaveModel? leaveModel) {
  final items = <LeaveDropdownItem>[];

  if (leaveModel == null) return items;

  final leaveByEmp = leaveModel.leaveByEmp;
  final leaveTypes = leaveModel.leaveTypes ?? [];

  for (final type in leaveTypes) {
    final code = type.leavetype ?? '';
    String balance = "0.00";

    switch (code.toUpperCase()) {
      case 'CL':
        balance = leaveByEmp?.cl ?? "0.00";
        break;
      case 'PL':
        balance = leaveByEmp?.pl ?? "0.00";
        break;
      case 'SL':
        balance = leaveByEmp?.sl ?? "0.00";
        break;
      case 'UPL':
        balance = leaveByEmp?.usedUpl ?? "0.00";
        break;
    }
    // 👇 Skip if balance == 0 or 0.0
    if (code.toUpperCase() != 'UPL' && (double.tryParse(balance) ?? 0) <= 0) {
      continue;
    }
    final label = code.toUpperCase() == 'UPL'
        ? code
        : "$code - $balance Left";
    items.add(LeaveDropdownItem(
      code: code,
      label: label,
      type: type, // keep the full object
    ));
  }

  return items;
}