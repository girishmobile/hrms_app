import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../provider/OnboardingProvider.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final PageController controller = PageController();

  final List<Map<String, String>> data = [
    {
      "title": "Manage Leave",
      "desc": "Apply and track your leaves with ease.",
      "img": "assets/lottie/img1.jpg",
      "anim": "assets/lottie/leave.json",
    },
    {
      "title": "KPI Dashboard",
      "img": "assets/lottie/img2.jpg",
      "desc": "Check your performance progress.",
      "anim": "assets/lottie/kpi.json",
    },
    {
      "title": "Profile",
      "img": "assets/lottie/img3.jpg",
      "desc": "Maintain personal and professional info.",
      "anim": "assets/lottie/profile.json",
    },
    {
      "title": "Calendar",
      "img": "assets/lottie/img4.jpg",
      "desc": "Plan daily tasks & events easily.",
      "anim": "assets/lottie/calendar.json",
    },
    {
      "title": "Attendance",
      "img": "assets/lottie/img4.jpg",
      "desc": "Track attendance logs with a tap.",
      "anim": "assets/lottie/attendance.json",
    },
  ];

  Future<void> askPermissions(BuildContext context) async {
    var cam = await Permission.camera.request();
    var loc = await Permission.locationWhenInUse.request();

    if (cam.isGranted && loc.isGranted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Permissions Granted!")));
    } else {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<OnboardingProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              data[p.currentIndex == data.length ? 0 : p.currentIndex]["img"]!,
              fit: BoxFit.cover,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.3)),

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
                      color: i == p.currentIndex ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                   /* decoration: BoxDecoration(
                      color: i == p.currentIndex
                          ? Colors.white
                          : Colors.white54,
                      borderRadius: BorderRadius.circular(20),
                    )*/
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 Bottom Buttons (Now also inside background)
              bottomButtons(context, p),

              const SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPage(Map<String, String> item, BuildContext context) {
    return Stack(
      children: [
        /// 🔹 Page Content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie.asset(item["anim"]!, height: 220),
              const SizedBox(height: 20),

              Text(
                item["title"]!,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // important for readability
                ),
              ),

              const SizedBox(height: 10),

              Text(
                item["desc"]!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Permission Page
  Widget permissionPage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //  Lottie.asset("assets/lottie/permission.json", height: 230),
        const Text(
          "Permissions Needed",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "For complete HRMS access we require Camera & Location permissions.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 25),
        ElevatedButton(
          onPressed: () => askPermissions(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text("Allow Permissions"),
        ),
      ],
    );
  }

  // Bottom Buttons
  Widget bottomButtons(BuildContext context, OnboardingProvider p) {
    return p.currentIndex == data.length
        ? ElevatedButton(
            onPressed: () => askPermissions(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text("Get Started"),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: const Text("Skip"),
                onPressed: () => controller.jumpToPage(data.length),
              ),
              TextButton(
                child: const Text("Next →"),
                onPressed: () {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          );
  }
}
