import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/constants/date_utils.dart';
import 'package:hrms/core/constants/string_utils.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:provider/provider.dart';

import '../../provider/dashboard_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  Future<void> init() async {
    final profile = Provider.of<DashboardProvider>(context, listen: false);

    await profile.getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
      appBar: commonAppBar(
        title: "Notification",
        context: context,
        centerTitle: true,
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsetsGeometry.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                physics: BouncingScrollPhysics(),
                itemCount: provider.notificationList.length,
                itemBuilder: (context, index) {
                  var data = provider.notificationList[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorBg),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        spacing: 5,
                        children: [
                          Container(
                            width: 100,
                            decoration: BoxDecoration(
                              color: colorSale.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            height: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                commonText(
                                  fontSize: 12,
                                  color: colorSale,
                                  fontWeight: FontWeight.w600,
                                  text: formatDate(
                                    data.createdAt?.date ??
                                        DateTime.now().toString(),
                                    format: "dd",
                                  ),
                                ),
                                commonText(
                                  fontSize: 14,
                                  color: colorSale,
                                  fontWeight: FontWeight.w700,
                                  text: formatDate(
                                    data.createdAt?.date ??
                                        DateTime.now().toString(),
                                    format: "MMM",
                                  ),
                                ),
                                commonText(
                                  fontSize: 12,
                                  color: colorSale,
                                  fontWeight: FontWeight.w600,
                                  text: formatDate(
                                    data.createdAt?.date ??
                                        DateTime.now().toString(),
                                    format: "yyyy",
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Html(
                                    data: data.title ?? '',
                                    style: {
                                      "body": Style(
                                        margin: Margins.zero,
                                        padding: HtmlPaddings.zero,
                                      ),
                                      "span": Style(
                                        fontSize: FontSize(14),
                                        fontFamily: fontRoboto,
                                        color: colorProduct,
                                        margin: Margins.zero,
                                        padding: HtmlPaddings.zero,
                                      ),
                                    },
                                  ),
                                  Html(
                                    data: data.details ?? '',
                                    style: {
                                      "body": Style(
                                        margin: Margins.zero,
                                        padding: HtmlPaddings.zero,
                                      ),
                                      "span": Style(
                                        fontSize: FontSize(12),
                                        fontFamily: fontRoboto,
                                        color: Colors.black,
                                        margin: Margins.zero,
                                        padding: HtmlPaddings.zero,
                                      ),
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                alignment: Alignment.centerRight,

                                decoration: BoxDecoration(
                                  color: colorSale.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                ),
                                height: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showCommonDialog(
                                          title: "Delete",
                                          context: context,
                                          confirmText: "Yes",
                                          cancelText: "No",
                                          onPressed: () async {
                                            Navigator.of(
                                              context,
                                            ).pop(); // 🔹 Pehle dialog band karo

                                            await provider.deleteNotification(
                                              id: data.id ?? 0,
                                            );

                                            init();
                                          },
                                          content:
                                              "Are you sure want to delete notification?",
                                        );
                                      },
                                      icon: Icon(
                                        Icons.delete_outlined,
                                        color: colorSale,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              provider.isLoading ? showLoaderList() : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}
