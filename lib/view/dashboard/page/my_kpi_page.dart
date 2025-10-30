import 'package:flutter/material.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/widgets/component.dart';

class MyKpiPage extends StatefulWidget {
  const MyKpiPage({super.key});

  @override
  State<MyKpiPage> createState() => _MyKpiPageState();
}

class _MyKpiPageState extends State<MyKpiPage> {
  final List<Map<String, dynamic>> monthData = [
    {"month": "January", "icon": Icons.calendar_month_outlined, "percent": 75},
    {"month": "February", "icon": Icons.calendar_month_outlined, "percent": 60},
    {"month": "March", "icon": Icons.calendar_month_outlined, "percent": 82},
    {"month": "April", "icon": Icons.calendar_month_outlined, "percent": 90},
    {"month": "May", "icon": Icons.calendar_month_outlined, "percent": 40},
    {"month": "June", "icon": Icons.calendar_month_outlined, "percent": 55},
    {"month": "July", "icon": Icons.calendar_month_outlined, "percent": 68},
    {"month": "August", "icon": Icons.calendar_month_outlined, "percent": 77},
    {
      "month": "September",
      "icon": Icons.calendar_month_outlined,
      "percent": 84,
    },
    {"month": "October", "icon": Icons.calendar_month_outlined, "percent": 92},
    {"month": "November", "icon": Icons.calendar_month_outlined, "percent": 63},
    {"month": "December", "icon": Icons.calendar_month_outlined, "percent": 88},
  ];

  String selectedYear = "2025";
  // default selected year
  List<String> years = ["2021", "2022", "2023", "2024", "2025"];

  final GlobalKey _buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsGeometry.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              commonText(
                text: "My KRA KPI",
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorProduct,
                //style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              //year drop down
              GestureDetector(
                key: _buttonKey,
                onTap: () => _showYearPopover(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: colorProduct.withValues(alpha: 0.05),
                    border: Border.all(color: colorProduct),
                  ),
                  child: Row(
                    spacing: 4,
                    children: [
                      Text(
                        selectedYear,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: colorProduct,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: colorProduct),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            itemCount: monthData.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, index) {
              final item = monthData[index];
              return _buildMonthCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMonthCard(Map<String, dynamic> item) {
    return Card(
      color: _getColor(item["percent"]).withValues(alpha: 0.04),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: colorBorder),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item["icon"],
              size: 32,
              color: colorProduct.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 10),
            Text(
              item["month"],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colorProduct,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "${item["percent"]}%",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getColor(item["percent"]),
              ),
            ),
          ],
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

  void _showYearPopover(BuildContext context) async {
    // Get button position
    final RenderBox button =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final Offset buttonPosition = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );
    final Size buttonSize = button.size;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        buttonPosition.dx,
        buttonPosition.dy + buttonSize.height + 4, // pop below button
        overlay.size.width - buttonPosition.dx - buttonSize.width,
        0,
      ),
      items: years.map((year) {
        return PopupMenuItem<String>(
          value: year,
          child: Text(
            year,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    if (selected != null && selected != selectedYear) {
      setState(() {
        selectedYear = selected;
      });
    }
  }
}

/**
 StatefulBuilder(
                builder: (context, setState) {
                  return DropdownButton<String>(
                    value: selectedYear,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    items: years.map((year) {
                      return DropdownMenuItem<String>(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value!;
                      });
                    },
                  );
                },
              ), */
