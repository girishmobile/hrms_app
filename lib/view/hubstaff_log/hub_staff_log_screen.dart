import 'package:flutter/material.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:provider/provider.dart';

import '../../core/constants/color_utils.dart';
import '../../data/models/hub_staff_model/hun_staff_model.dart';
import '../../provider/dashboard_provider.dart';

class HubStaffLogScreen extends StatefulWidget {
  const HubStaffLogScreen({super.key});

  @override
  State<HubStaffLogScreen> createState() => _HubStaffLogScreenState();
}

class _HubStaffLogScreenState extends State<HubStaffLogScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  Future<void> init() async {
    final profile = Provider.of<DashboardProvider>(context, listen: false);

    await profile.getHubStaffLog();
  }

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
      appBar: commonAppBar(title: "HubStaff Logs", context: context,centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Consumer<DashboardProvider>(
          builder: (context, provider, child) {
            return commonRefreshIndicator(
              onRefresh: () async {
                init();
              },
              child: Stack(
                children: [
                  Column(
                    spacing: 8,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(

                          decoration: commonBoxDecoration(
                            color: colorBg,
                            borderColor: colorBorder

                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              commonText(

                                text: "Total Week : ",
                                color: colorProduct,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              commonText(
                                color: colorProduct,
                                text: provider.hubStaffModel?.weekTotal ?? "0",
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1.2,
                              ),
                          itemCount: provider.hubStaffModel?.days?.length ?? 0,
                          itemBuilder: (context, index) {
                            var data = provider.hubStaffModel?.days?[index];
                            final color =
                            provider.colors[index %
                                provider.colors.length]; // pick color cyclically
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: commonView(data: data,colorBG: color),
                            );
                          },
                        ),
                      ),
                      //
                    ],
                  ),
                  provider.isLoading ? showLoaderList() : SizedBox.shrink(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget commonView({Days? data,Color ? colorBG}) {
  return commonInkWell(
    child: Container(
      decoration: commonBoxDecoration(
        borderColor: colorBorder,
        color: colorBG?.withValues(alpha: 0.05)??Colors.grey.shade100, // 👈 Dynamic background color
      ),

      height: 60,
      child: Container(
        width: 80,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
          ),
          color: colorBorder.withValues(alpha: 0.05),
        ),
        child: Column(
          spacing: 6,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            commonText(
              color: colorBG,
              text: data?.dayNum ?? "0",
              fontWeight: FontWeight.w700,
              fontSize: 26,
            ),

            IntrinsicHeight(
              child: Row(
                spacing: 2,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  commonText(
                    text: data?.dayName ?? "0",
                    fontWeight: FontWeight.w600,
                  ),

                  VerticalDivider(color: colorBorder),
                  commonText(
                    text: data?.month ?? "0",
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),

            commonText(
              text: data?.time ?? "0",
              color: colorBG,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ],
        ),
      ),
    ),
  );
}
