import 'package:flutter/material.dart';
import 'package:hrms/core/routes/app_routes.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/main.dart';
import 'package:provider/provider.dart';

import '../../core/constants/image_utils.dart';
import '../../provider/login_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return commonScaffold(
      body: Consumer<LoginProvider>(
        builder: (context, provider, child) {
          return commonAppBackground(
            child: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: AlignmentGeometry.center,
                          child: commonAssetImage(
                            icAppLogo,
                            height: 72,

                            width: size.width * 0.7,
                          ),
                        ),
                        SizedBox(height: size.height * 0.06),
                        commonTextFieldView(
                          text: "Email",
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: commonPrefixIcon(image: icEmail),
                        ),
                        const SizedBox(height: 15),
                        commonTextFieldView(
                          text: "Password",
                          keyboardType: TextInputType.visiblePassword,

                          prefixIcon: commonPrefixIcon(image: icPassword),
                          obscureText: provider.obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              color: Colors.grey,
                              provider.obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: provider.togglePassword,
                          ),
                        ),

                        SizedBox(height: 3),
                        commonInkWell(
                          onTap: () {},
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: commonText(
                              fontSize: 12,
                              text: "Forgot Password?",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        commonButton(
                          text: "Login",
                          onPressed: () {
                            navigatorKey.currentState?.pushNamed(
                              RouteName.dashboardScreen,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
