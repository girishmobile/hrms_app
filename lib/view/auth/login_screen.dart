import 'package:flutter/material.dart';
import 'package:hrms/core/routes/app_routes.dart';
import 'package:hrms/core/widgets/common_uuid.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:hrms/main.dart';
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
                                height: 120,

                                width: size.width ,
                              ),
                            ),
                            SizedBox(height: size.height * 0.05),
                            commonTextFieldView(
                              text: "Email",
                              controller: provider.tetEmail,
                            /*  validator: (value) => emptyError(
                                value,
                                errorMessage: "Email is required",
                              ),*/
                               validator: validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: commonPrefixIcon(image: icEmail),
                            ),
                            const SizedBox(height: 15),
                            commonTextFieldView(
                              validator: (value) => emptyError(
                                value,
                                errorMessage: "Password is required",
                              ),
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

                            SizedBox(height: 8),
                            commonInkWell(
                              onTap: () {

                                navigatorKey.currentState?.pushNamed(RouteName.forgotPassword);
                              },
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

                                hideKeyboard(context);
                                if (formLoginKey.currentState?.validate() ==
                                    true) {
                                  print("Login Pressed");
                                  Map<String, dynamic> body = {
                                    "email": provider.tetEmail.text.trim(),
                                    "password": provider.tetPassword.text
                                        .trim(),
                                    "isLogin": "1",
                                    "uuid": CommonUuid.generateUUID(),
                                  };

                                  provider.loginApi(body: body);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  provider.isLoading ? showLoaderList() : SizedBox.shrink(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
