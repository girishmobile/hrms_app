import 'package:flutter/material.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/main.dart';
import 'package:hrms/provider/leave_provider.dart';
import 'package:hrms/view/add_leave/add_leave_screen.dart';
import 'package:provider/provider.dart';

import '../../core/constants/date_utils.dart';

class LeaveDetailsScreen extends StatefulWidget {
  final String? title;
  final Color? color;

  const LeaveDetailsScreen({super.key, this.title, this.color});

  @override
  State<LeaveDetailsScreen> createState() => _LeaveDetailsScreenState();
}

class _LeaveDetailsScreenState extends State<LeaveDetailsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  Future<void> init() async {
    final profile = Provider.of<LeaveProvider>(context, listen: false);
    final Map<String, dynamic> body = {
      "draw": 1,
      "columns": [
        {
          "data": 0,
          "name": "id",
          "searchable": true,
          "orderable": false,
          "search": {"value": "", "regex": false},
        },
        {
          "data": 1,
          "name": "leavetype",
          "searchable": true,
          "orderable": true,
          "search": {"value": "", "regex": false},
        },
        {
          "data": 2,
          "name": "leave_date",
          "searchable": true,
          "orderable": true,
          "search": {
            "value": widget.title == "All" ? "all" : "",
            "regex": false,
          },
        },
        {
          "data": 3,
          "name": "leave_end_date",
          "searchable": true,
          "orderable": true,
          "search": {"value": "", "regex": false},
        },
        {
          "data": 4,
          "name": "leave_count",
          "searchable": true,
          "orderable": true,
          "search": {
            "value": widget.title == "All" ? "all" : widget.title,
            "regex": false,
          },
        },
        {
          "data": 5,
          "name": "status",
          "searchable": true,
          "orderable": true,
          "search": {"value": "", "regex": false},
        },
      ],
      "order": [],
      "start": 0,
      "length": 15,
      "search": {"value": widget.title == "All" ? "" : "", "regex": false},
    };

    await profile.getAllLeave(body: body);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LeaveProvider>(
      builder: (context, provider, child) {
        return commonScaffold(
          appBar: commonAppBar(
            context: context,
            centerTitle: true,
            title: widget.title ?? 'Leaves',
          ),
          body: commonRefreshIndicator(
            onRefresh: () async {
              init();
            },
            child: Stack(
              children: [
                provider.allLeaveModel?.data?.isEmpty == true
                    ? Center(child: Text("No ${widget.title ?? ''} available"))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.allLeaveModel?.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          final data = provider.allLeaveModel?.data?[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: widget.color ?? colorBorder,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.only(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              top: 0,
                            ),
                            child: Column(
                              children: [
                                IntrinsicHeight(
                                  child: Row(
                                    spacing: 1,
                                    children: [
                                      fromToView(
                                        from:
                                            data?.leaveDate?.date ??
                                            DateTime.now().toString(),
                                        to:
                                            data?.leaveEndDate?.date ??
                                            DateTime.now().toString(),
                                        color: widget.color ?? Colors.red,
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
                                              widget.color?.withValues(
                                                alpha: 0.03,
                                              ) ??
                                              Colors.white,
                                          child: Column(
                                            spacing: 8,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              commonItemView(
                                                title: "Leave Type",
                                                value: data?.halfDay == true
                                                    ? '${data?.leaveType?.leavetype} - ${data?.halfDayType}'
                                                    : '${data?.leaveType?.leavetype}',
                                              ),
                                              commonItemView(
                                                title: "Reason",
                                                value: data?.reason ?? '',
                                              ),

                                              commonItemView(
                                                title: "Days",
                                                value:
                                                    '${data?.leaveCount} Days',
                                              ),
                                              /* commonItemView(
                                                title: "Applied On",
                                                value: '${data['appliedOn']}',
                                              ),*/
                                              commonItemView(
                                                title: "Status",
                                                customView: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          commonBoxDecoration(
                                                            borderRadius: 4,
                                                            borderColor:
                                                                widget.color ??
                                                                Colors.red,
                                                            color:
                                                                widget.color
                                                                    ?.withValues(
                                                                      alpha:
                                                                          0.04,
                                                                    ) ??
                                                                Colors.red,
                                                          ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 5,
                                                              horizontal: 5,
                                                            ),
                                                        child: Center(
                                                          child: commonText(
                                                            text:
                                                                data?.status ??
                                                                '',
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              data?.status == "Pending"
                                                  ? Row(
                                                      spacing: 20,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Expanded(
                                                          child: commonInkWell(
                                                            onTap: () {
                                                              navigatorKey.currentState?.push(
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (
                                                                        context,
                                                                      ) => AddLeaveScreen(
                                                                        data:
                                                                            data,
                                                                      ),
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              decoration:
                                                                  commonBoxDecoration(
                                                                    borderRadius:
                                                                        4,
                                                                    borderColor:
                                                                        colorProduct,
                                                                  ),
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical: 8,
                                                                  ),
                                                              child: Center(
                                                                child: commonText(
                                                                  text:
                                                                      "Edit Leave",
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        Expanded(
                                                          child: commonInkWell(
                                                            onTap: () async {
                                                              showCommonDialog(
                                                                title: "Delete",
                                                                context:
                                                                    context,
                                                                content:
                                                                    "Are you sure want to delete leave?",
                                                                confirmText:
                                                                    "Yes",
                                                                cancelText:
                                                                    "No",
                                                                onPressed: () async {
                                                                  Navigator.of(
                                                                    context,
                                                                  ).pop(); // 🔹 Pehle dialog band karo

                                                                  final Map<
                                                                    String,
                                                                    dynamic
                                                                  >
                                                                  body = {
                                                                    "id":
                                                                        data?.id ??
                                                                        0,
                                                                  };

                                                                  await provider
                                                                      .deleteLeave(
                                                                        body:
                                                                            body,
                                                                      );

                                                                  init();
                                                                },
                                                              );
                                                            },
                                                            child: Container(
                                                              decoration:
                                                                  commonBoxDecoration(
                                                                    borderRadius:
                                                                        4,
                                                                    borderColor:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical: 8,
                                                                  ),
                                                              child: Center(
                                                                child: commonText(
                                                                  text:
                                                                      "Delete",
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : SizedBox.shrink(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                provider.isLoading ? showLoaderList() : SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
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
