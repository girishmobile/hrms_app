import 'package:flutter/material.dart';
import 'package:hrms/core/constants/string_utils.dart';
import 'package:hrms/provider/dashboard_provider.dart';
import 'package:hrms/provider/profile_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/color_utils.dart';
import '../../../core/constants/date_utils.dart';
import '../../../core/constants/image_utils.dart';
import '../../../core/hive/app_config_cache.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/component.dart';
import '../../../core/widgets/profile_view.dart';
import '../../../main.dart';

Widget profileTopView({required ProfileProvider provider,Color? colorText,Color ? colorBorder}) {
  var data = provider.profileModel;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
        child: ProfileView(
          colorBorder:colorBorder ,
          assetPath: data?.gender?.valueText == "Male" ? icBoy : icGirl,
        ),
      ),

      SizedBox(height: 15),
      commonText(
        text: '${data?.firstname ?? ''} ${data?.lastname ?? ''}',
        textAlign: TextAlign.center,
        color: colorText,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      commonText(
        text: data?.email ?? '',
        textAlign: TextAlign.center,
        fontWeight: FontWeight.w400,
        color: colorText,
        fontSize: 13,
      ),
    ],
  );
}

Widget basicInfoWidget({required ProfileProvider provider}) {
  var data = provider.profileModel;

  return commonBoxView(
    contentView: Column(
      spacing: 12,

      children: [
        commonRowLeftRightView(
          title: 'Full Name',
          value: '${data?.firstname ?? ''} ${data?.lastname ?? ''}',
        ),

        commonRowLeftRightView(
          title: 'Employee ID',
          customView: commonText(
            text: data?.employeeId ?? "-",
            textAlign: TextAlign.right,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        commonRowLeftRightView(
          title: 'Personal Email',
          value: data?.email ?? "-",
        ),
        commonRowLeftRightView(
          title: 'Company Email',
          value: data?.companyEmail ?? "-",
        ),
        commonRowLeftRightView(
          title: 'Gender',
          value: data?.gender?.valueText ?? '',
        ),
        commonRowLeftRightView(
          title: 'Birthday',
          value: formatDate(
            data?.dateOfBirth?.date ?? '',
            format: "dd-MM-yyyy",
          ),
        ),
        commonRowLeftRightView(
          title: 'Marital Status',
          value: data?.maritalStatus == true ? 'Married' : 'Unmarried',
        ),
        commonRowLeftRightView(
          title: 'Blood Group',
          value: data?.bloodGroup ?? '-',
        ),
        commonRowLeftRightView(
          title: 'Status',
          customView: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: commonBoxDecoration(
                  borderRadius: 5,
                  borderColor: data?.userExitStatus == true
                      ? Colors.green
                      : Colors.red,
                  borderWidth: 0.5,

                  color: data?.userExitStatus == true
                      ? Colors.green.withValues(alpha: 0.10)
                      : Colors.red.withValues(alpha: 0.10),
                ),
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                child: commonText(
                  text: data?.userExitStatus == true ? "Active" : "Inactive",
                  textAlign: TextAlign.right,
                  color: data?.userExitStatus == true
                      ? Colors.green
                      : Colors.red,
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
  );
}

Widget contactInfoWidget({required ProfileProvider provider}) {
  var data = provider.profileModel;
  return commonBoxView(
    contentView: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        commonRowLeftRightView(
          title: 'Mobile Phone',
          value: data?.contactNo ?? '-',
        ),
        commonRowLeftRightView(
          title: 'Emergency Contact Number',
          value: data?.emergencyContactNo ?? '-',
        ),
        commonRowLeftRightView(
          title: 'Emergency Contact Person',
          value: data?.emergencyContactPerson ?? '-',
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
              text: data?.address ?? '-',
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
              text: data?.perAddress ?? '-',

              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ],
        ),
      ],
    ),
    title: 'Contact Information',
  );
}

Widget companyInfoWidget({required ProfileProvider provider}) {
  var data = provider.profileModel;
  return commonBoxView(
    contentView: Column(
      spacing: 12,
      children: [
        commonRowLeftRightView(
          title: 'Department',
          value: data?.department?.name ?? "-",
        ),
        commonRowLeftRightView(
          title: 'Designation',
          value: data?.designation?.name ?? "-",
        ),
        commonRowLeftRightView(
          title: 'Batch',
          value: data?.location?.name ?? "-",
        ),
        commonRowLeftRightView(
          title: 'Joining Date',
          value: formatDate(
            data?.joiningDate?.date ?? "-",
            format: "dd-MM-yyyy",
          ),
        ),
        commonRowLeftRightView(
          title: 'Work Duration',
          value: calculateWorkDuration(data?.joiningDate?.date),
        ),
      ],
    ),
    title: 'Company Relations',
  );
}

Widget documentInfoWidget({required ProfileProvider provider}) {
  var data = provider.profileModel;
  return commonBoxView(
    contentView: Column(
      spacing: 12,
      children: [
        commonRowLeftRightView(
          title: 'Driving License Number',
          value: data?.drivingLicenseNumber?? "-",
        ),
        commonRowLeftRightView(
          title: 'PAN Number',
          value: data?.panNumber ?? "-",
        ),
        commonRowLeftRightView(
          title: 'Aadhar Number/SSN',
          value: data?.aadharNumber ?? "-",
        ),
        commonRowLeftRightView(
          title: 'Voter ID Number',
          value: data?.voterIdNumber?? "-",
        ),
      ],
    ),
    title: 'Document',
  );
}

Widget immigrationInfoWidget({required ProfileProvider provider}) {
  var data = provider.profileModel;
  return commonBoxView(
    contentView: Column(
      spacing: 12,
      children: [
        commonBoxView(
          fontSize: 12,
          title: "Passport Information",
          contentView: Column(
            spacing: 12,
            children: [
              commonRowLeftRightView(
                title: 'Number',
                value: data?.passportNumber ?? "-",
              ),
              commonRowLeftRightView(
                title: 'Issue Date',
                value: data?.passportIssueDate ?? "-",
              ),
              commonRowLeftRightView(
                title: 'Expiry Date',
                value: data?.passportExpiryDate ?? "-",
              ),
              commonRowLeftRightView(
                title: 'Scanned Copy',
                value: data?.passportImage ?? "-",
              ),
            ],
          ),
        ),
        commonBoxView(
          fontSize: 12,
          title: "Visa Information",
          contentView: Column(
            spacing: 12,
            children: [
              commonRowLeftRightView(
                title: 'Number',
                value: data?.voterIdNumber ?? "-",
              ),
              commonRowLeftRightView(
                title: 'Issue Date',
                value: data?.visaIssueDate ?? "-",
              ),
              commonRowLeftRightView(
                title: 'Expiry Date',
                value: data?.visaExpiryDate ?? "-",
              ),
              commonRowLeftRightView(
                title: 'Scanned Copy',
                value: data?.visaImage ?? "-",
              ),
            ],
          ),
        ),
      ],
    ),
    title: 'Immigration',
  );
}
Widget socialInfoWidget({required ProfileProvider provider}) {
  var data = provider.profileModel;
  return commonBoxView(
    contentView: Column(
      spacing: 12,
      children: [
        commonRowLeftRightView(
          title: 'Slack username',
          value: data?.slackUsername?? "-",
        ),
        commonRowLeftRightView(
          title: 'Facebook username',
          value: data?.facebookUsername ?? "-",
        ),
        commonRowLeftRightView(
          title: 'Twitter username',
          value: data?.twitterUsername ?? "-",
        ),
        commonRowLeftRightView(
          title: 'LinkedIn username',
          value: data?.linkdinUsername?? "-",
        ),
      ],
    ),
    title: 'Social Network',
  );
}
Widget logoutButton(BuildContext context) {
  return commonButton(
    color: colorProduct,
    radius: 8,
    text: "Logout",
    onPressed: () {
      final dashboardProvider = context.read<DashboardProvider>();
      showCommonDialog(
        confirmText: "Yes",
        onPressed: () async {
          dashboardProvider.setIndex(2);
          dashboardProvider.setAppBarTitle(home);

          await AppConfigCache.clearUserData();
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
  );
}
Widget updatePasswordButton(BuildContext context) {
  return commonButton(
    color: colorUser,
    radius: 8,
    text: "Update Password",
    onPressed: () {
      navigatorKey.currentState?.pushNamed(
        RouteName.updatePasswordScreen,

      );
    },
  );
}