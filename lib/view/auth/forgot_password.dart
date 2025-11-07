import 'package:flutter/material.dart';
import 'package:hrms/core/constants/color_utils.dart';
import 'package:hrms/core/widgets/component.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/image_utils.dart';
import '../../../core/constants/validation.dart';
import '../../../provider/login_provider.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    final formLoginKey = GlobalKey<FormState>();
    return commonScaffold(

     
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
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: commonInkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 45,
                          height: 45,

                          decoration: commonBoxDecoration(
                            color: colorProduct,
                            shape: BoxShape.circle
                          ),
                          child: Center(
                            child: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
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

                            Align(
                                alignment: AlignmentGeometry.center,
                                child: commonText(text: "Enter your email to reset password",textAlign: TextAlign.center,fontSize: 16,fontWeight: FontWeight.w500)),

                            SizedBox(height: 20,),
                            commonTextFieldView(
                              text: "Enter",
                              controller: provider.tetEmail,
                              validator: (value) => emptyError(
                                value,
                                errorMessage: "Email is required",
                              ),
                              //   validator: validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: commonPrefixIcon(image: icEmail),
                            ),
                            const SizedBox(height: 36),
                            commonButton(
                              text: "Send reset link",
                              onPressed: () {

                                hideKeyboard(context);
                                if (formLoginKey.currentState?.validate() ==
                                    true) {
                                  Map<String, dynamic> body = {
                                    "email": provider.tetEmail.text.trim(),

                                  };

                                  provider.forgotPassword(body: body);
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
