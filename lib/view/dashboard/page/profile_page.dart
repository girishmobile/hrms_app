import 'package:flutter/material.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/constants/image_utils.dart';
import 'package:hrms/core/widgets/component.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/profile_view.dart';
import '../../../main.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      physics: BouncingScrollPhysics(),
      children: [
        Center(child: ProfileView(assetPath: icDummyUser)),

        SizedBox(height: 15),
        commonText(
          text: "Sameer Khan",
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        commonText(
          text: "sameer@redefinesolutions.com",
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
        SizedBox(height: 15),
        commonBoxView(
          contentView: Column(
            spacing: 8,

            children: [
              commonRowLeftRightView(title: 'Full Name', value: 'Sameer Khan'),
              commonRowLeftRightView(
                title: 'Employee ID',
                customView: commonText(
                  text: "150",
                  textAlign: TextAlign.right,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              commonRowLeftRightView(
                title: 'Personal Email',
                value: 'sameer@redefine..',
              ),
              commonRowLeftRightView(
                title: 'Company Email',
                value: 'sameer@redefine..',
              ),
              commonRowLeftRightView(title: 'Gender', value: 'Male'),
              commonRowLeftRightView(title: 'Birthday', value: '12-12-1993'),
              commonRowLeftRightView(title: 'Marital Status', value: 'Married'),
              commonRowLeftRightView(title: 'Blood Group', value: 'B+'),
              commonRowLeftRightView(
                title: 'Status',
                customView: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: commonBoxDecoration(
                        borderRadius: 5,
                        borderColor: Colors.green,
                        borderWidth: 0.5,

                        color: Colors.green.withValues(alpha: 0.10),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 10,
                      ),
                      child: commonText(
                        text: "Active",
                        textAlign: TextAlign.right,
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          title: 'Basic Information',
        ),

        SizedBox(height: 15),
        commonBoxView(
          contentView: Column(

            spacing: 8,
            children: [
              commonRowLeftRightView(
                title: 'Mobile Phone',
                value: '0932892332',
              ),
              commonRowLeftRightView(
                title: 'Emergency Contact Number',
                value: '0932892332',
              ),
              commonRowLeftRightView(
                title: 'Emergency Contact Person',
                value: 'Kaushalam Digital Pvt. Ltd',
              ),

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonText(
                text: "Current Address",
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              commonText(
                text: 'Turquoise 3, BLOCK-A, 501, Gala Gymkhana Rd, South Bopal, Bopal, Ahmedabad, Gujarat 380058',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ],
          ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonText(
                    text: "Permanent Address",
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  commonText(
                    text:'Turquoise 3, BLOCK-A, 501, Gala Gymkhana Rd, South Bopal, Bopal, Ahmedabad, Gujarat 380058',

                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ],
              ),


            ],
          ),
          title: 'Contact Information',
        ),
        SizedBox(height: 15),

        commonBoxView(
          contentView: Column(
            spacing: 8,
            children: [
              commonRowLeftRightView(
                title: 'Department',
                value: 'Mobile Application Developer',
              ),
              commonRowLeftRightView(
                title: 'Designation',
                value: 'Flutter Developer',
              ),
              commonRowLeftRightView(
                title: 'Batch',
                value: 'Batch:- 9:30 to 7:30',
              ),
              commonRowLeftRightView(
                title: 'Joining Date',
                value: '06-05-2024',
              ),
              commonRowLeftRightView(
                title: 'Work Duration',
                value: '1 year, 5 months, 22 days ago',
              ),
            ],
          ),
          title: 'Company Relations',
        ),
        SizedBox(height: 30),

        commonButton(
          color: colorRed,
          radius: 8,
          text: "Logout",
          onPressed: () {
            showCommonDialog(
              confirmText: "Yes",
              onPressed: () async {
                navigatorKey.currentState?.pushNamedAndRemoveUntil(
                  RouteName.loginScreen,
                  (Route<dynamic> route) => false,
                );
              },
              cancelText: "No",
              title: "Logout?",
              context: context,
              content: "Are you sure want to logout",
            );
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
