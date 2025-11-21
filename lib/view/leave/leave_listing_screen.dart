import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/provider/leave_provider.dart';
import 'package:provider/provider.dart';

import '../../core/constants/date_utils.dart';
import '../../core/constants/string_utils.dart';
import '../../core/hive/app_config_cache.dart';
import '../../core/hive/user_model.dart';
import '../../core/widgets/cached_image_widget.dart';
import '../../data/models/leave/leave_listing_model.dart';

class LeaveListingScreen extends StatefulWidget {
  const LeaveListingScreen({super.key,this.hideAppBar});
  final bool? hideAppBar;
  @override
  State<LeaveListingScreen> createState() => _LeaveListingScreenState();
}

class _LeaveListingScreenState extends State<LeaveListingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await init();
    });
  }

  Future<void> init() async {
    final provider = Provider.of<LeaveProvider>(context, listen: false);

    await provider.getAllListingLeave();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return commonScaffold(
      appBar:widget.hideAppBar==true? PreferredSize(preferredSize: Size.zero, child: SizedBox.shrink()):commonAppBar(
        title: "Leave Request",
        context: context,
        centerTitle: true,
      ),
      body: commonRefreshIndicator(
        onRefresh: () async {
          init();
        },
        child: Consumer<LeaveProvider>(
          builder: (context, provider, child) {
            final model = provider.leaveDashboardModel;

            if (model == null) {
              return provider.isLoading
                  ? showLoaderList()
                  : Center(child: Text("No data found"));
            }
            /*    final recentPendingLeaves = model.data.data.
                .where(
                  (e) => e["0"]["status"].toString().toLowerCase() == "pending",
                )
                .toList();*/
            /* final items = [
              {
                "title": "Today Leaves",
                "count": model.todayLeavesCount,
                "list": model.todayLeaves,
              },
              {
                "title": "Recent Leaves",
                "count": recentPendingLeaves.length,
                "list": recentPendingLeaves,
              },
              {
                "title": "Early Leaves",
                "count": model.earlyLeavesCount,
                "list": model.earlyLeaves,
              },
            ];*/

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.data?.data?.length,
                    /* gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 columns
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.3,
                        ),*/
                    itemBuilder: (context, index) {
                      var data = model.data?.data?[index];
                      final startDate =
                          data?.leaveDate?.date ?? DateTime.now().toString();
                      final endDate =
                          data?.leaveEndDate?.date ?? DateTime.now().toString();

                      String formattedDate;

                      if (startDate == endDate) {
                        // Same Date
                        formattedDate = formatDate(
                          startDate,
                          format: "dd MMM yyyy",
                        );
                      } else {
                        // Date Range
                        formattedDate =
                            '${formatDate(startDate, format: "dd MMM yyyy")} to ${formatDate(endDate, format: "dd MMM yyyy")}';
                      }

                      Color borderColor =
                          provider.colors[index % provider.colors.length];
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: commonBoxDecoration(
                            color: borderColor.withValues(alpha: 0.03),
                            borderColor: colorBorder,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 0.0,
                            vertical: 8,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 5,
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CachedImageWidget(
                                  width: 45,
                                  height: 45,
                                  borderRadius: 22.5,
                                  imageUrl: data?.userId?.profileImage ?? '',
                                ),
                                subtitle: commonText(
                                  text: formattedDate,
                                  fontSize: 12,
                                ),
                                title: commonText(
                                  text:
                                      "${data?.userId?.firstname ?? ''} ${data?.userId?.lastname ?? ''}",
                                  // text: items[index]["title"].toString(),
                                  textAlign: TextAlign.start,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                trailing: Container(
                                  decoration: commonBoxDecoration(
                                    borderWidth: 0.6,
                                    borderRadius: 4,
                                    color:
                                        data?.status.toString().toLowerCase() ==
                                            "pending"
                                        ? Colors.amber.withValues(alpha: 0.05)
                                        : data?.status
                                                  .toString()
                                                  .toLowerCase() ==
                                              "accept"
                                        ? Colors.green.withValues(alpha: 0.05)
                                        : Colors.red.withValues(alpha: 0.05),
                                    borderColor:
                                        data?.status.toString().toLowerCase() ==
                                            "pending"
                                        ? Colors.amber.withValues(alpha: 1)
                                        : data?.status
                                                  .toString()
                                                  .toLowerCase() ==
                                              "accept"
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 3,
                                    ),
                                    child: commonText(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      text:
                                          data?.status
                                                  .toString()
                                                  .toLowerCase() ==
                                              "accept"
                                          ? "Approved"
                                          : '${data?.status.toString()}',
                                      color:
                                          data?.status
                                                  .toString()
                                                  .toLowerCase() ==
                                              "pending"
                                          ? Colors.amber
                                          : data?.status
                                                    .toString()
                                                    .toLowerCase() ==
                                                "accept"
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              data?.status.toString().toLowerCase() == "pending"
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5.0,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        spacing: 10,

                                        children: [
                                          commonButton(
                                            onTap: () async {
                                              UserModel? user =
                                                  await AppConfigCache.getUserModel();

                                              if (user?.data?.user?.id !=
                                                  data?.userId?.id) {
                                                showCommonDialog(
                                                  onPressed: () async {
                                                    Map<String, dynamic> body =
                                                        {"id": data?.id ?? 0};

                                                    /*    Navigator.of(
                                                      context,
                                                    ).pop(); // close dialog
*/
                                                    await provider
                                                        .approvedLeave(
                                                          body: body,
                                                        );
                                                  },
                                                  title: "Approved",
                                                  context: context,
                                                  content:
                                                      "Are you sure you want to approve this leave ?",
                                                  confirmText: "Yes",
                                                  cancelText: "No",
                                                );
                                              } else {
                                                showCommonDialog(
                                                  title: "Action Not Allowed",
                                                  context: context,
                                                  showCancel: false,
                                                  content:
                                                      "You can't approve your own leave.",
                                                  confirmText: "Close",
                                                  cancelText: "No",
                                                );
                                              }
                                            },
                                          ),
                                          commonButton(
                                            title: "Decline",
                                            colorBg: Colors.red,
                                            onTap: () async {
                                              UserModel? user =
                                                  await AppConfigCache.getUserModel();

                                              if (user?.data?.user?.id !=
                                                  data?.userId?.id) {
                                                showCommonDialog(
                                                  onPressed: () async {
                                                    if (provider
                                                        .tetRejectReason
                                                        .text
                                                        .isNotEmpty) {
                                                      Map<String, dynamic>
                                                      body = {
                                                        "id": data?.id ?? 0,
                                                        "reject_reason":
                                                            provider
                                                                .tetRejectReason
                                                                .text,
                                                      };

                                                      await provider
                                                          .rejectLeave(
                                                            body: body,
                                                          );
                                                    } else {
                                                      showCommonDialog(
                                                        showCancel: false,
                                                        cancelText: "Close",
                                                        title: "Error",
                                                        context: context,
                                                        content:
                                                            "Please enter valid reason ",
                                                      );
                                                    }
                                                  },

                                                  title: "Reject Leave",
                                                  context: context,
                                                  contentView: Material(
                                                    color: Colors.transparent,
                                                    child: Column(
                                                      spacing: 10,
                                                      children: [
                                                        SizedBox(height: 10),
                                                        commonText(
                                                          text:
                                                              "Are you sure you want to reject this leave ?",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        commonTextField(
                                                          controller: provider
                                                              .tetRejectReason,
                                                          hintText:
                                                              "Enter reject reason",
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  confirmText: "Yes",
                                                  cancelText: "No",
                                                );
                                              } else {
                                                showCommonDialog(
                                                  title: "Action Not Allowed",
                                                  context: context,
                                                  showCancel: false,
                                                  content:
                                                      "You can't decline your own leave.",
                                                  confirmText: "Close",
                                                  cancelText: "No",
                                                );
                                              }
                                            },
                                          ),
                                          commonButton(
                                            title: "Info",
                                            colorBg: Colors.grey,
                                            onTap: () async {
                                              showCommonBottomSheet(
                                                context: context,
                                                content: SizedBox(
                                                  height: size.height * 0.7,
                                                  child: Column(
                                                    spacing: 10,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          commonText(
                                                            text:
                                                                'Leave Details',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: colorLogo,
                                                            fontSize: 16,
                                                          ),
                                                          commonInkWell(
                                                            onTap: () {
                                                              Navigator.of(
                                                                context,
                                                              ).pop();
                                                            },
                                                            child: Container(
                                                              width: 35,
                                                              height: 35,
                                                              decoration:
                                                                  commonBoxDecoration(
                                                                    color:
                                                                        colorLogo,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                              child: Center(
                                                                child: Icon(
                                                                  size: 15,
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 0),
                                                      Expanded(
                                                        child: LeavesListScreen(
                                                          data: data,
                                                          date: formattedDate,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ) /*Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              commonText(
                               text: "ss",
                                // text: items[index]["title"].toString(),
                                textAlign: TextAlign.center,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(height: 10),
                              commonText(
                               // text: items[index]["count"].toString(),
                                text: '',
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: borderColor,
                              ),
                            ],
                          )*/,
                        ),
                      );
                    },
                  ),
                ),
                provider.isLoading ? showLoaderList() : SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget commonButton({String? title, Color? colorBg, void Function()? onTap}) {
    return commonInkWell(
      onTap: onTap,
      child: Container(
        decoration: commonBoxDecoration(
          borderRadius: 4,
          color:
              colorBg?.withValues(alpha: 0.06) ??
              Colors.green.withValues(alpha: 0.06),
          borderWidth: 0.6,
          borderColor:
              colorBg?.withValues(alpha: 0.7) ??
              Colors.green.withValues(alpha: 0.7),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
          child: Center(
            child: commonText(
              text: title ?? "Accept",
              color: colorBg ?? Colors.green,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class LeavesListScreen extends StatelessWidget {
  final DataItem? data;

  final String date;

  const LeavesListScreen({super.key, required this.data, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        spacing: 15,
        mainAxisAlignment: .start,
        crossAxisAlignment: .start,

        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CachedImageWidget(
              width: 45,
              height: 45,
              borderRadius: 22.5,
              imageUrl: data?.userId?.profileImage ?? '',
            ),
            subtitle: commonText(text: date),
            title: commonText(
              text:
                  "${data?.userId?.firstname ?? ''} ${data?.userId?.lastname ?? ''}",
              // text: items[index]["title"].toString(),
              textAlign: TextAlign.start,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            trailing: Container(
              decoration: commonBoxDecoration(
                borderRadius: 4,
                color: data?.status.toString().toLowerCase() == "pending"
                    ? Colors.amber.withValues(alpha: 0.05)
                    : data?.status.toString().toLowerCase() == "accept"
                    ? Colors.green.withValues(alpha: 0.05)
                    : Colors.red.withValues(alpha: 0.05),
                borderColor: data?.status.toString().toLowerCase() == "pending"
                    ? Colors.amber.withValues(alpha: 1)
                    : data?.status.toString().toLowerCase() == "accept"
                    ? Colors.green
                    : Colors.red,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 3,
                ),
                child: commonText(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  text: data?.status.toString().toLowerCase() == "accept"
                      ? "Approved"
                      : '${data?.status.toString()}',
                  color: data?.status.toString().toLowerCase() == "pending"
                      ? Colors.amber
                      : data?.status.toString().toLowerCase() == "accept"
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
          ),
          commonColumn(
            title: "Leave Type",
            value: data?.leaveType?.leavetype ?? '',
          ),
          commonColumn(title: "Date", value: date),

          commonColumn(
            title: "Half Day",
            value: data?.halfDay == true ? "Yes" : "No",
          ),
          commonColumn(title: "Days", value: data?.leaveCount ?? "0"),
          commonColumn(title: "Location", value: data?.location ?? '-'),

          Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              commonText(
                text: "Reason",
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              commonText(
                text: data?.reason ?? '',
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ],
          ),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: .start,
              crossAxisAlignment: .start,
              children: [
                commonText(
                  text: "Leave History",
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data?.leaveHistory?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Html(
                        data: data?.leaveHistory?[index].msg ?? '',
                        style: {
                          "body": Style(
                            fontSize: FontSize(12),
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                          "span": Style(
                            fontSize: FontSize(12),
                            fontFamily: fontRoboto,
                            color: colorProduct,
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget commonColumn({required String title, required String value}) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      crossAxisAlignment: .start,

      children: [
        commonText(text: title, fontWeight: FontWeight.w400, fontSize: 13),
        commonText(text: value, fontWeight: FontWeight.w500, fontSize: 13),
      ],
    );
  }
}
