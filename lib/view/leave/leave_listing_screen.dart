import 'package:flutter/material.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/provider/leave_provider.dart';
import 'package:provider/provider.dart';

import '../../core/constants/date_utils.dart';
import '../../core/hive/app_config_cache.dart';
import '../../core/hive/user_model.dart';
import '../../core/widgets/cached_image_widget.dart';

class LeaveListingScreen extends StatefulWidget {
  const LeaveListingScreen({super.key});

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
      appBar: commonAppBar(
        title: "`Leave Request",
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
              return const Center(child: Text("No data found"));
            }
            final recentPendingLeaves = model.recentLeaves
                .where(
                  (e) => e["0"]["status"].toString().toLowerCase() == "pending",
                )
                .toList();
            final items = [
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
            ];
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 columns
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.3,
                        ),
                    itemBuilder: (context, index) {
                      Color borderColor =
                          provider.colors[index % provider.colors.length];
                      return GestureDetector(
                        onTap: () {
                          showCommonBottomSheet(
                            context: context,
                            content: SizedBox(
                              height: size.height * 0.7,
                              child: Column(
                                spacing: 10,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      commonText(
                                        text: items[index]["title"].toString(),
                                        fontWeight: FontWeight.w600,
                                        color: colorLogo,
                                        fontSize: 16,
                                      ),
                                      commonInkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          width: 35,
                                          height: 35,
                                          decoration: commonBoxDecoration(
                                            color: colorLogo,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Icon(
                                              size: 15,
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: LeavesListScreen(
                                      color: borderColor,
                                      provider: provider,
                                      title: items[index]["title"].toString(),
                                      leaves: items[index]["list"] as List,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: commonBoxDecoration(
                            color: borderColor.withValues(alpha: 0.03),
                            borderColor: borderColor,
                          ),

                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                commonText(
                                  text: items[index]["title"].toString(),
                                  textAlign: TextAlign.center,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                const SizedBox(height: 10),
                                commonText(
                                  text: items[index]["count"].toString(),
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: borderColor,
                                ),
                              ],
                            ),
                          ),
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
}

class LeavesListScreen extends StatelessWidget {
  final String title;
  final Color color;
  final List leaves;
  final LeaveProvider provider;

  const LeavesListScreen({
    super.key,
    required this.title,
    required this.provider,
    required this.color,
    required this.leaves,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: leaves.length,
      itemBuilder: (context, index) {
        final item = leaves[index];
        final leave = item["0"];
        final startDate = leave['leave_date']['date'];
        final endDate = leave['leave_end_date']['date'];

        String formattedDate;

        if (startDate == endDate) {
          // Same Date
          formattedDate = formatDate(startDate, format: "dd MMM yyyy");
        } else {
          // Date Range
          formattedDate =
              '${formatDate(startDate, format: "dd MMM yyyy")} to ${formatDate(endDate, format: "dd MMM yyyy")}';
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          decoration: commonBoxDecoration(
            color: color.withValues(alpha: 0.01),
            borderColor: colorBorder,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  trailing: Container(
                    decoration: commonBoxDecoration(
                      borderRadius: 4,
                      color:
                          leave['status'].toString().toLowerCase() == "pending"
                          ? Colors.amber.withValues(alpha: 0.05)
                          : leave['status'].toString().toLowerCase() == "accept"
                          ? Colors.green.withValues(alpha: 0.05)
                          : Colors.red.withValues(alpha: 0.05),
                      borderColor:
                          leave['status'].toString().toLowerCase() == "pending"
                          ? Colors.amber.withValues(alpha: 1)
                          : leave['status'].toString().toLowerCase() == "accept"
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
                            leave['status'].toString().toLowerCase() == "accept"
                            ? "Approved"
                            : leave['status'],
                        color:
                            leave['status'].toString().toLowerCase() ==
                                "pending"
                            ? Colors.amber
                            : leave['status'].toString().toLowerCase() ==
                                  "accept"
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,

                  subtitle: commonText(fontSize: 12, text: formattedDate),
                  title: commonText(
                    color: colorLogo,
                    text: '${item['firstname']}  ${item['lastname']}',
                    fontWeight: FontWeight.w600,
                  ),
                  leading: CachedImageWidget(
                    width: 45,
                    height: 45,
                    borderRadius: 22.5,
                    imageUrl: item["profile_image"],
                  ),
                ),

                Row(
                  children: [
                    commonText(
                      text: 'Reason:',
                      fontWeight: FontWeight.w600,
                      color: colorLogo,
                    ),
                    commonText(
                      color: Colors.black.withValues(alpha: 0.6),
                      text: ' ${leave['reason']}',
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                leave['status'].toString().toLowerCase() == "pending"
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 10,

                          children: [
                            commonButton(
                              onTap: () async {
                                UserModel? user =
                                    await AppConfigCache.getUserModel();

                                if (user?.data?.user?.id != item['emp_id']) {
                                  showCommonDialog(
                                    onPressed: () async {
                                      Map<String, dynamic> body = {
                                        "id": leave["id"],
                                      };

                                      Navigator.of(
                                        context,
                                      ).pop(); // close dialog
                                      Navigator.of(
                                        context,
                                      ).pop(); // close dialog
                                      await provider.approvedLeave(body: body);
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

                                if (user?.data?.user?.id != item['emp_id']) {
                                  showCommonDialog(
                                    onPressed: () async {
                                      if (provider
                                          .tetRejectReason
                                          .text
                                          .isNotEmpty) {
                                        Map<String, dynamic> body = {
                                          "id": leave["id"],
                                          "reject_reason":
                                              provider.tetRejectReason.text,
                                        };

                                        Navigator.of(
                                          context,
                                        ).pop(); // close dialog
                                        Navigator.of(
                                          context,
                                        ).pop(); // close dialog
                                        await provider.rejectLeave(body: body);
                                      } else {
                                        showCommonDialog(
                                          showCancel: false,
                                          cancelText: "Close",
                                          title: "Error",
                                          context: context,
                                          content: "Please enter valid reason ",
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
                                            textAlign: TextAlign.center,
                                          ),
                                          commonTextField(
                                            controller:
                                                provider.tetRejectReason,
                                            hintText: "Enter reject reason",
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
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ) /*ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                "YOUR_IMAGE_URL/${item["profile_image"]}",
              ),
            ),
            title: Text(
              "${item["firstname"]} ${item["lastname"]}",
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Designation: ${item['designation']}"),
                Text("Leave Type: ${item['leavetype']}"),
                Text("Reason: ${leave['reason']}"),
                Text("Status: ${leave['status']}"),
                Text("Date: ${leave['leave_date']['date']}"),
              ],
            ),
          )*/,
        );
      },
    );
  }

  Widget commonButton({String? title, Color? colorBg, void Function()? onTap}) {
    return commonInkWell(
      onTap: onTap,
      child: Container(
        decoration: commonBoxDecoration(
          borderRadius: 4,
          color: colorBg ?? Colors.green,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
          child: Center(
            child: commonText(
              text: title ?? "Accept",
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
