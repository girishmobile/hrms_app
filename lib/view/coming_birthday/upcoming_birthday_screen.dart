import 'package:flutter/material.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_config.dart';
import '../../core/constants/color_utils.dart';
import '../../core/constants/date_utils.dart';
import '../../core/widgets/cached_image_widget.dart';

class UpcomingBirthdayScreen extends StatelessWidget {
  const UpcomingBirthdayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
      appBar: commonAppBar(
        title: "All Birthday",
        context: context,
        centerTitle: true,
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              //padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                itemCount: provider.birthdayModel?.birthdays?.length ?? 0,
              itemBuilder: (context, index) {
                final item = provider.birthdayModel?.birthdays?[index];
                if (item == null) {
                  return const SizedBox(); // prevent null crash
                }

                // safely parse date
                DateTime birthDate;
                try {
                  birthDate = DateTime.parse(
                    item.dateOfBirth?.date ?? DateTime.now().toString(),
                  );
                } catch (_) {
                  birthDate = DateTime.now();
                }

                final bgColor = provider.getBirthdayBgColor(birthDate);

                return commonInkWell(
                  onTap: () {},
                  child: Container(

                    margin: EdgeInsets.only(bottom: 8),

                    decoration: commonBoxDecoration(
                      color: bgColor.withValues(alpha: 0.1),
                      borderColor: colorBorder,
                      borderRadius: 8,
                    ),

                    child: IntrinsicHeight(
                      child: Row(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(8),

                            child: CachedImageWidget(

                              width: 120,


                              borderRadius: 8,
                              imageUrl:
                                  '${ApiConfig.imageBaseUrl}/${item.profileImage ?? ''}',
                            ),
                          ),

                          Column(
                            spacing: 3,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              commonText(
                                text: '${item.firstname} ${item.lastname}',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: colorProduct,
                              ),

                              commonText(
                                text: '${item.designation}',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: colorProduct,
                              ),
                              Row(
                                children: [
                                  commonText(
                                    fontWeight: FontWeight.w400,
                                    text: formatDay(
                                      item.dateOfBirth?.date ??
                                          DateTime.now().toString(),
                                    ),
                                    fontSize: 12,
                                    color: colorText,
                                  ),

                                  commonText(
                                    fontWeight: FontWeight.w400,
                                    text: formatDate(
                                      item.dateOfBirth?.date ??
                                          DateTime.now().toString(),
                                      format: "MMMM yyyy",
                                    ),
                                    fontSize: 12,
                                    color: colorText,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
