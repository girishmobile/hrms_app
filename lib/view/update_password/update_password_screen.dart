import 'package:flutter/material.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:provider/provider.dart';

import '../../core/constants/image_utils.dart';
import '../../core/constants/validation.dart';
import '../../core/hive/app_config_cache.dart';
import '../../core/hive/user_model.dart';
import '../../provider/login_provider.dart';

class UpdatePasswordScreen extends StatelessWidget {
  const UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    final formKey = GlobalKey<FormState>();

    return commonScaffold(
      appBar: commonAppBar(

        title: "Change Password",
        context: context,

        centerTitle: true,
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        /*  decoration: commonBoxDecoration(
          image: DecorationImage(fit: BoxFit.fill, image: AssetImage(icImg1)),
        ),*/
        child: Consumer<LoginProvider>(
          builder: (context, provider, child) {
            return commonAppBackground(
              color: Colors.transparent,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 56),
                          Align(
                            alignment: Alignment.center,
                            child: commonAssetImage(
                              icAppLogo,
                              height: 120,
                              width: size.width,
                            ),
                          ),
                          const SizedBox(height: 56),

                          // 🔑 Current Password
                          commonTextFieldView(
                            validator: (value) => emptyError(
                              value,
                              errorMessage: "Current password is required",
                            ),
                            text: "Current Password",
                            keyboardType: TextInputType.visiblePassword,
                            controller: provider.tetCurrentPassword,
                            prefixIcon: commonPrefixIcon(image: icPassword),
                            obscureText: provider.obscureCurrentPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                provider.obscureCurrentPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: provider.toggleCurrentPassword,
                            ),
                          ),
                          const SizedBox(height: 15),

                          // 🆕 New Password
                          commonTextFieldView(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "New password is required";
                              } else if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                            text: "New Password",
                            keyboardType: TextInputType.visiblePassword,
                            controller: provider.tetNewPassword,
                            prefixIcon: commonPrefixIcon(image: icPassword),
                            obscureText: provider.obscureNewPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                provider.obscureNewPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: provider.toggleNewPassword,
                            ),
                          ),
                          const SizedBox(height: 15),

                          // ✅ Confirm Password
                          commonTextFieldView(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Confirm password is required";
                              } else if (value !=
                                  provider.tetNewPassword.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                            text: "Confirm Password",
                            keyboardType: TextInputType.visiblePassword,
                            controller: provider.tetConfirmPassword,
                            prefixIcon: commonPrefixIcon(image: icPassword),
                            obscureText: provider.obscureConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                provider.obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: provider.toggleConfirmPassword,
                            ),
                          ),
                          const SizedBox(height: 36),

                          // 🔘 Update Button
                          commonButton(
                            text: "Update",
                            onPressed: () async {
                              UserModel? user =
                                  await AppConfigCache.getUserModel();

                              hideKeyboard(context);
                              if (formKey.currentState?.validate() ?? false) {
                                Map<String, dynamic> body = {
                                  "id": user?.data?.user?.id,
                                  "password": provider.tetCurrentPassword.text
                                      .trim(),
                                  "new_password": provider.tetNewPassword.text
                                      .trim(),
                                  "confirm_new_password": provider
                                      .tetConfirmPassword
                                      .text
                                      .trim(),
                                };

                                await provider.updatePassword(body: body);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (provider.isLoading) showLoaderList(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
