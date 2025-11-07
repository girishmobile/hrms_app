import 'package:flutter/material.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/constants/image_utils.dart';
import 'package:hrms/core/widgets/component.dart';
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
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  physics: const BouncingScrollPhysics(),
                  children: [

                    Divider(height: 0.2,color: colorBorder.withValues(alpha: 0.05),),

                    Container(
                      decoration: BoxDecoration(
                        color: colorProduct,

                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: profileTopView(provider: provider,colorText: Colors.white,colorBorder: Colors.white),
                        )),
                    const SizedBox(height: 15),

                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                     child: Column(
                       children: [
                         commonView(),
                         const SizedBox(height: 15),
                         commonView(title: "Change Password"),
                         const SizedBox(height: 15),
                         commonView(title: "My Hours"),
                         const SizedBox(height: 15),
                         commonView(title: "All Holiday"),
                         const SizedBox(height: 30),

                         logoutButton(context),
                       ],
                     ),
                   )
                   /* basicInfoWidget(provider: provider),

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
                    const SizedBox(height: 20),*/
                  ],
                ),
                provider.isLoading?showLoaderList():SizedBox.shrink()
              ],
            );
          }
      ),
    );
  }
  
  
 Widget commonView({
    String ? title
}){
    return IntrinsicHeight(
      child: Container(
        decoration: commonBoxDecoration(
          borderColor: colorBorder
        ),

        height: 60,
        child: Row(
          spacing: 10,

          children: [

            Container(
              width: 80,
              height: double.infinity,
              decoration: BoxDecoration(

                borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8)),
                  color: colorBorder.withValues(alpha: 0.05)
              ),
              child: Center(
                child: commonAssetImage(icDelete,width: 24,height: 24,color: Colors.black.withValues(alpha: 0.5)),
              ),
            ),
            Expanded(child: commonText(text: title??"Edit Profile",fontWeight: FontWeight.w500),),
            
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.arrow_forward_outlined,size: 20,color:  Colors.black.withValues(alpha: 0.5),),
            )
          ],
        ),
      ),
    );
  }
}
