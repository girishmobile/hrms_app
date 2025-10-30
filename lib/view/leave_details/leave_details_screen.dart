import 'package:flutter/material.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../../core/constants/date_utils.dart';

class LeaveDetailsScreen extends StatelessWidget {
  final String? title;
  final Color? color;

  const LeaveDetailsScreen({super.key, this.title, this.color});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    final leaves = provider.getLeavesByType(title ?? 'All');

    return commonScaffold(
      appBar: commonAppBar(
        context: context,
        centerTitle: true,
        title: title ?? 'Leaves',
      ),
      body: leaves.isEmpty
          ? Center(child: Text("No ${title ?? ''} available"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: leaves.length,
              itemBuilder: (context, index) {
                final data = leaves[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: color ?? colorBorder),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.only(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      spacing: 1,
                      children: [
                        fromToView(
                          from: data['from'],
                          to: data['to'],
                          color: color ?? Colors.red,
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 0,
                              right: 16,
                              bottom: 16,
                              top: 16,
                            ),
                            color:
                                color?.withValues(alpha: 0.03) ?? Colors.white,
                            child: Column(
                              spacing: 8,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                commonItemView(
                                  title: "Leave Type",
                                  value: data['type'],
                                ),
                                commonItemView(
                                  title: "Reason",
                                  value: data['reason'],
                                ),

                                commonItemView(
                                  title: "Days",
                                  value: '${data['days']}',
                                ),
                                commonItemView(
                                  title: "Applied On",
                                  value: '${data['appliedOn']}',
                                ),
                                commonItemView(
                                  title: "Status",
                                  customView: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: commonBoxDecoration(
                                          borderRadius: 4,
                                          borderColor: color ?? Colors.red,
                                          color:
                                              color?.withValues(alpha: 0.04) ??
                                              Colors.red,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 5,
                                          ),
                                          child: Center(
                                            child: commonText(
                                              text: data['status'],
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget fromToView({String? from, String? to, required Color color}) {
    final formattedFrom = formatDate(from);
    final formattedTo = formatDate(to);
    return Container(
      decoration: commonBoxDecoration(
        // borderColor: color,
        color: color.withValues(alpha: 0.04),
        borderRadius: 8,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        spacing: 3,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //   commonText(text: "From", color: color, textAlign: TextAlign.center,fontSize: 12,fontWeight: FontWeight.w600),
          commonText(
            text: formattedFrom,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          commonText(
            text: "To",
            color: color,
            textAlign: TextAlign.center,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 4),
          commonText(
            text: formattedTo,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget commonItemView({String? title, String? value, Widget? customView}) {
    return Row(
      children: [
        Expanded(
          child: commonText(
            text: "$title :",
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        Expanded(
          child:
              customView ??
              commonText(
                textAlign: TextAlign.right,
                text: value ?? '',
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
        ),
      ],
    );
  }
}
