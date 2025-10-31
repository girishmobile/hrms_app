import 'package:flutter/material.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../dashboard/widget/home_widget.dart';

class UpcomingBirthdayScreen extends StatelessWidget {
  const UpcomingBirthdayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
        appBar: commonAppBar(title: "All Birthday", context: context,centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Consumer<DashboardProvider>(
                builder: (context,provider,child) {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16),
            itemCount:provider.allBirthdayDetails.length,
            itemBuilder: (context, index) {
              final item = provider.allBirthdayDetails[index];
              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: buildBirthdayItemView(
                  verticalPadding: 10,
                  item: item,
                  provider: provider,
                  context: context,
                ),
              );
            },
          );
                }
              ),
        ));
  }
}
