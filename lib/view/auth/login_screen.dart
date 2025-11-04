import 'package:flutter/material.dart';
import 'package:hrms/core/widgets/common_uuid.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:provider/provider.dart';

import '../../core/constants/image_utils.dart';
import '../../core/constants/validation.dart';
import '../../provider/login_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    final formLoginKey = GlobalKey<FormState>();
    return commonScaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: commonBoxDecoration(
          image: DecorationImage(fit: BoxFit.fill, image: AssetImage(icImg1)),
        ),
        child: Consumer<LoginProvider>(
          builder: (context, provider, child) {
            return commonAppBackground(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: formLoginKey,
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
                              controller: provider.tetEmail,
                              validator: (value) =>
                                  emptyError(value, errorMessage: "Password is required"),
                           //   validator: validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: commonPrefixIcon(image: icEmail),
                            ),
                            const SizedBox(height: 15),
                            commonTextFieldView(
                              validator: (value) =>
                                  emptyError(value, errorMessage: "Password is required"),
                              text: "Password",
                              keyboardType: TextInputType.visiblePassword,
                              controller: provider.tetPassword,
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
                                if (formLoginKey.currentState?.validate() == true) {
                                  Map<String, dynamic> body = {
                                    "email": provider.tetEmail.text.trim(),
                                    "password": provider.tetPassword.text.trim(),
                                    "isLogin": "1",
                                    "uuid":CommonUuid.generateUUID(),
                                  };

                                  print('$body');
                                  provider.loginApi(body: body);
                                }

                                /*navigatorKey.currentState?.pushNamed(
                                  RouteName.dashboardScreen,
                                );*/
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  provider.isLoading?showLoaderList():SizedBox.shrink()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
