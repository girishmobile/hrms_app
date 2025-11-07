import 'package:flutter/material.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/provider/profile_provider.dart';
import 'package:hrms/view/dashboard/widget/profile_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/hive/app_config_cache.dart';
import '../../../core/hive/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  Future<void> init() async {
    final profile = Provider.of<ProfileProvider>(context, listen: false);

    UserModel? user = await AppConfigCache.getUserModel();

    Map<String, dynamic> body = {
      "employee_id": user?.data?.user?.id,

    };


    await profile.getUserDetails(body: body);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ProfileProvider>(
        builder: (context,provider,child) {
          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                physics: const BouncingScrollPhysics(),
                children: [
                  profileTopView(provider: provider),
                  const SizedBox(height: 15),
                  basicInfoWidget(provider: provider),

                  const SizedBox(height: 15),
                  contactInfoWidget(provider: provider),
                  const SizedBox(height: 15),

                  companyInfoWidget(provider: provider),
                  const SizedBox(height: 15),

                  documentInfoWidget(provider: provider),
                  const SizedBox(height: 15),
                  immigrationInfoWidget(provider: provider),
                  const SizedBox(height: 15),
                  socialInfoWidget(provider: provider),
                  const SizedBox(height: 30),


                  logoutButton(context),
                  const SizedBox(height: 15),
                  updatePasswordButton(context),
                  const SizedBox(height: 20),
                ],
              ),
              provider.isLoading?showLoaderList():SizedBox.shrink()
            ],
          );
        }
      ),
    );
  }
}
