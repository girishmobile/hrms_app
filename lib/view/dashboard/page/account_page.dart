import 'package:flutter/material.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/constants/image_utils.dart';
import 'package:hrms/core/routes/app_routes.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/main.dart';
import 'package:hrms/provider/profile_provider.dart';
import 'package:hrms/view/dashboard/widget/profile_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/hive/app_config_cache.dart';
import '../../../core/hive/user_model.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  Future<void> init() async {
    final provider = Provider.of<ProfileProvider>(context, listen: false);

    UserModel? user = await AppConfigCache.getUserModel();

    Map<String, dynamic> body = {"employee_id": user?.data?.user?.id};

    await provider.getUserDetails(body: body);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: commonRefreshIndicator(
        onRefresh: ()async{
          init();
        },
        child: Consumer<ProfileProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                //  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 15),

                    // Divider(height: 0.2,color: colorBorder.withValues(alpha: 0.05),),
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: profileTopView(
                          provider: provider,
                          colorText: colorProduct,
                          colorBorder: colorProduct,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 0,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        commonView(
                          onTap: () {
                            navigatorKey.currentState?.pushNamed(
                              RouteName.profileScreen,
                            );
                          },
                          image: icEdit,
                          bgColor: Colors.blue.shade50, // light blue
                        ),
                        const SizedBox(height: 15),
                        commonView(
                          title: "Change Password",
                          onTap: () {
                            navigatorKey.currentState?.pushNamed(
                              RouteName.updatePasswordScreen,
                            );
                          },
                          image: icPassword,
                          bgColor: Colors.pink.shade50,
                        ),
                        const SizedBox(height: 15),
                        commonView(
                          title: "My Hours",
                          onTap: () {
                            navigatorKey.currentState?.pushNamed(
                              RouteName.myWorkScreen,
                            );
                          },
                          bgColor: Colors.green.shade50,
                          image: icTime,
                        ),
                        const SizedBox(height: 15),
                        commonView(
                          title: "Hotline",
                          onTap: () {
                            navigatorKey.currentState?.pushNamed(
                              RouteName.hotlineScreen,
                            );
                          },
                          bgColor: Colors.orange.shade50,
                          image: icMenuProfile,
                        ),

                        /*   const SizedBox(height: 15),
                        commonView(
                          title: "Hubstaff Logs ",
                          onTap: () {
                            navigatorKey.currentState?.pushNamed(
                              RouteName.hubStaffLogScreen,
                            );
                          },
                          bgColor: Colors.orange.shade50,
                          image: icHubStaff,
                        ),*/
                        const SizedBox(height: 36),

                          logoutButton(context),
                        ],
                      ),
                    ),
                  ],
                ),
                provider.isLoading ? showLoaderList() : SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget commonView({
    String? title,
    String? image,
    void Function()? onTap,
    Color? bgColor,
  }) {
    return commonInkWell(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Container(
          decoration: commonBoxDecoration(
            borderColor: colorBorder,
            color:
                bgColor ?? Colors.grey.shade100, // 👈 Dynamic background color
          ),

          height: 60,
          child: Row(
            spacing: 10,

            children: [
              Container(
                width: 80,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  color: colorBorder.withValues(alpha: 0.05),
                ),
                child: Center(
                  child: commonAssetImage(
                    image ?? icDelete,
                    width: 24,
                    height: 24,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ),
              ),
              Expanded(
                child: commonText(
                  text: title ?? "Edit Profile",
                  fontWeight: FontWeight.w500,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.arrow_forward_outlined,
                  size: 20,
                  color: Colors.black.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
