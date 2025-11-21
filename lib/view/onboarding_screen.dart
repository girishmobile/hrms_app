import 'package:flutter/material.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/constants/image_utils.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/provider/location_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../core/hive/app_config_cache.dart';
import '../core/routes/app_routes.dart';
import '../main.dart';
import '../provider/onboarding_provider.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final PageController controller = PageController();

  final List<Map<String, String>> data = [
    {
      "title": "Manage Leave",
      "desc": "Apply and track your leaves with ease.",
      "img": "assets/lottie/img2.jpg",
      "anim": "assets/lottie/leave.json",
    },
    {
      "title": "KPI Dashboard",
      "img": "assets/lottie/img3.jpg",
      "desc": "Check your performance progress.",
      "anim": "assets/lottie/kpi.json",
    },
    {
      "title": "Profile",
      "img": "assets/lottie/img4.jpg",
      "desc": "Maintain personal and professional info.",
      "anim": "assets/lottie/profile.json",
    },
    {
      "title": "Calendar",
      "img": "assets/lottie/img5.jpg",
      "desc": "Plan daily tasks & events easily.",
      "anim": "assets/lottie/calendar.json",
    },
    {
      "title": "Attendance",
      "img": "assets/lottie/img6.jpg",
      "desc": "Track attendance logs with a tap.",
      "anim": "assets/lottie/attendance.json",
    },
  ];

  Future<void> askPermissions(BuildContext context, bool isPermission) async {
    bool alreadyGiven = await AppConfigCache.isLocationPermissionGiven();
    if (alreadyGiven) {
      await AppConfigCache.saveOnBoarding(true);
      if (!isPermission) {
        if (context.mounted) {
          navigatorKey.currentState?.pushReplacementNamed(
            RouteName.loginScreen,
          );
        }
      }
    } else {
      final provider = Provider.of<LocationProvider>(context, listen: false);
      await provider.requestPermissionsAndFetchData(isAddress: false);
      if (!isPermission) {
        if (context.mounted) {
          navigatorKey.currentState?.pushReplacementNamed(
            RouteName.loginScreen,
          );
        }
        await AppConfigCache.saveOnBoarding(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<OnboardingProvider>(context);
    //final provider =  Provider.of<LocationProvider>(context, listen: false);
    return Scaffold(
      body: Consumer<LocationProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  data[p.currentIndex.clamp(0, data.length - 1)]["img"]!,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                ),
              ),
              Container(color: Colors.black.withValues(alpha: 0.7)),

              Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: controller,
                      itemCount: data.length + 1, // last = permissions
                      onPageChanged: (i) => p.setPage(i),
                      itemBuilder: (context, i) {
                        if (i == data.length) {
                          return permissionPage(context);
                        }
                        return buildPage(data[i], context);
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      data.length + 1,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.all(4),
                        width: i == p.currentIndex ? 22 : 10,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == p.currentIndex
                              ? Colors.white
                              : Colors.white54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 Bottom Buttons (Now also inside background)
                  bottomButtons(context, p),

                  const SizedBox(height: 30),
                ],
              ),
              /* Center(
                child: showLoaderList(color:  Colors.black,colorBG: Colors.white),
              ),*/
              if (provider.loading)
                Center(
                  child: showLoaderList(
                    color: Colors.black,
                    colorBG: Colors.white,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget buildPage(Map<String, String> item, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          commonText(
            text: item["title"] ?? '',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white, // important for readability
          ),

          const SizedBox(height: 10),

          commonText(
            text: item["desc"] ?? '',
            textAlign: TextAlign.center,
            fontSize: 16,
            color: Colors.white70,
          ),
        ],
      ),
    );
  }

  // Permission Page
  Widget permissionPage(BuildContext context) {
    final provider = Provider.of<LocationProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /*    commonAssetImage(

          width: 250,
            icAppLogo,height: 230),*/
        //  Lottie.asset("assets/lottie/permission.json", height: 230),
        commonText(
          text: "Permissions Needed",
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        commonText(
          text:
              "For complete HRMS access we require Camera & Location permissions.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
        const SizedBox(height: 56),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 12),
          child: commonButton(
            height: 45,
            color: Colors.red,
            text: "Allow Permissions",
            onPressed: () async {
              askPermissions(context, true);
            },
          ),
        ),
      ],
    );
  }

  // Bottom Buttons
  Widget bottomButtons(BuildContext context, OnboardingProvider p) {
    return p.currentIndex == data.length
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: commonButton(
              height: 45,
              color: Colors.white,
              fontSize: 12,
              textColor: colorProduct,
              text: "Get Started",
              onPressed: () async {
                await askPermissions(context, false);
                await AppConfigCache.saveOnBoarding(true);
              },
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              spacing: 100,
              mainAxisAlignment: .start,
              children: [
                Expanded(
                  child: commonButton(
                    height: 35,
                    fontSize: 12,
                    color: Colors.redAccent,
                    text: "Skip",
                    onPressed: () async {
                      await AppConfigCache.saveOnBoarding(true);
                      navigatorKey.currentState?.pushNamedAndRemoveUntil(
                        RouteName.loginScreen,
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: commonButton(
                    height: 35,
                    color: Colors.white,
                    textColor: colorProduct,
                    fontSize: 12,
                    text: "Next",
                    onPressed: () {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
