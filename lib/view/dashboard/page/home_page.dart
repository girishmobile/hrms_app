import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/routes/app_routes.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/main.dart';
import 'package:hrms/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../widget/home_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  Future<void> init() async {
    final profile = Provider.of<DashboardProvider>(context, listen: false);



    await profile.getBirthdayHoliday();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              physics: const BouncingScrollPhysics(),
              children: [
                commonHomeRowView(
                  title: "Record Your Attendance",
                  isHideSeeMore: true,
                ),

                const SizedBox(height: 10),

                Container(
                  decoration: commonBoxDecoration(
                    borderColor: colorProduct.withValues(alpha: 0.3),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    spacing: 30,
                    children: [
                      Row(
                        children: [
                          commonTopView(desc: "Days", value: 1),
                          commonTopView(desc: "Days", value: 0, title: "Late"),
                          commonTopView(desc: "Days", value: 1, title: "Absent"),
                        ],
                      ),
                      Row(
                        children: [
                          commonTopView(desc: "Days", value: 0, title: "Half Days"),
                          commonTopView(
                            desc: "hr",
                            value: 1,
                            title: "Worked hours",
                          ),
                          Spacer(),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                commonHomeRowView(title: "My Leaves", isHideSeeMore: true),

                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,

                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16),
                  itemCount: provider.leaves.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 columns
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.3,
                  ),
                  itemBuilder: (context, index) {
                    final item = provider.leaves[index];
                    return buildItemView(
                      item: item,
                      provider: provider,
                      context: context,
                    );
                  },
                ),

                commonHomeRowView(onTap: (){
                  navigatorKey.currentState?.pushNamed(RouteName.holidayScreen);
                }),
                const SizedBox(height: 10),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16),
                    itemCount: min(provider.birthdayModel?.holidays?.length??0, 5),
                    itemBuilder: (context, index) {
                      final item = provider.birthdayModel?.holidays?[index];
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: buildHolidayItemView(
                          item: item,
                          provider: provider,
                          context: context,
                        ),
                      );
                    },
                  ),
                ),
                commonHomeRowView(title: "Upcoming Birthday",
                onTap: (){
                  navigatorKey.currentState?.pushNamed(RouteName.upcomingBirthdayScreen);
                }),
                const SizedBox(height: 10),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16),
                    itemCount: min(provider.birthdayModel?.birthdays?.length??0, 5),
                    itemBuilder: (context, index) {
                      final item = provider.birthdayModel?.birthdays?[index];
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: buildBirthdayItemView(
                          item: item,
                          provider: provider,
                          context: context,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            provider.isLoading?showLoaderList():SizedBox.shrink()
          ],
        );
      },
    );
  }
}
