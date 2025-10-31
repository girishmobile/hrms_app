import 'package:flutter/material.dart';
import 'package:hrms/view/dashboard/widget/profile_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          profileTopView(),
          const SizedBox(height: 15),
          basicInfoWidget(),

          const SizedBox(height: 15),
          contactInfoWidget(),
          const SizedBox(height: 15),

          companyInfoWidget(),
          const SizedBox(height: 30),

          logoutButton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
