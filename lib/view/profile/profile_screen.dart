import 'package:flutter/cupertino.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/view/dashboard/page/profile_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return commonScaffold(
      appBar: commonAppBar(
        title: " Edit Profile",
        context: context,
        centerTitle: true,
      ),
      body: ProfilePage(),
    );
  }
}
