import 'package:flutter/cupertino.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../dashboard/widget/home_widget.dart';

class HolidayScreen extends StatelessWidget {
  const HolidayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
      appBar: commonAppBar(title: "Holiday", context: context,centerTitle: true),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [

                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16),
                    itemCount: provider.allHolidayDetails.length,
                    itemBuilder: (context, index) {
                      final item = provider.allHolidayDetails[index];
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: buildHolidayItemView(
                          verticalPadding: 10,
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
          );
        },
      ),
    );
  }
}
