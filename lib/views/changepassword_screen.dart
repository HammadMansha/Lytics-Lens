import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Constants/app_strrings.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/widget/common_button/common_button.dart';
import 'package:lytics_lens/widget/snackbar/common_snackbar.dart';
import 'package:lytics_lens/Controllers/changepassword_controller.dart';
import 'package:lytics_lens/widget/textFields/common_textfield.dart';

import '../widget/form_validator/validator.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final mqDataNew = mqData.copyWith(
        textScaleFactor:
            mqData.textScaleFactor > 1.0 ? 1.0 : mqData.textScaleFactor);

    return MediaQuery(
      data: mqDataNew,
      child: Scaffold(
        backgroundColor: Color(0xff000425),
        appBar: AppBar(
          backgroundColor: Color(0xff000425),
          title: Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              "Change Password",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ).marginOnly(top: 25),
          ),
          elevation: 0.0,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.keyboard_backspace_rounded,
            ).marginOnly(left: 34, top: 25),
          ),
        ),
        body: bodyData(context),
      ),
    );
  }

  Widget bodyData(context) {
    return GetBuilder<ChangePasswordController>(
        init: ChangePasswordController(),
        builder: (_) {
          return SizedBox(
            height: Get.height,
            width: Get.width,
            child: SingleChildScrollView(
              child: Form(
                key: _.formKey,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Current Password",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ).marginOnly(top: 79, left: 34),
                    CommonTextField(
                            fillcolor: CommonColor.textFieldBackgrounfColour,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                  RegExp(r"\s\b|\b\s"))
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter current password';
                              }
                              return null;
                            },
                            hintText: 'Current Password',
                            togglePassword: true,
                            toggleIcon: _.securetext == true
                                ? Icons.visibility_off_outlined
                                : Icons.remove_red_eye_outlined,
                            toggleFunction: () {
                              _.securetext = !_.securetext;
                              _.update();
                            },
                            hintTextColor: Colors.white.withOpacity(0.6),
                            controller: _.oldPassword,
                            isTextHidden: _.securetext)
                        .marginOnly(left: 34, top: 15, right: 66),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "New Password",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ).marginOnly(top: 15, left: 34),
                    CommonTextField(
                            fillcolor: CommonColor.textFieldBackgrounfColour,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                  RegExp(r"\s\b|\b\s"))
                            ],
                            togglePassword: true,
                            hintText: 'New Password',
                            validator: (value) {
                              return PasswordValidationWidget
                                  .validatePasswordOnPressed(value!);
                            },
                            toggleIcon: _.securetext1 == true
                                ? Icons.visibility_off_outlined
                                : Icons.remove_red_eye_outlined,
                            toggleFunction: () {
                              _.securetext1 = !_.securetext1;
                              _.update();
                            },
                            hintTextColor: Colors.white.withOpacity(0.6),
                            controller: _.newPassword,
                            isTextHidden: _.securetext1)
                        .marginOnly(left: 34, top: 15, right: 66),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Confirm New Password",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ).marginOnly(top: 15, left: 34),
                    CommonTextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
                      ],
                      fillcolor: CommonColor.textFieldBackgrounfColour,
                      togglePassword: true,
                      toggleIcon: _.securetext2 == true
                          ? Icons.visibility_off_outlined
                          : Icons.remove_red_eye_outlined,
                      toggleFunction: () {
                        _.securetext2 = !_.securetext2;
                        _.update();
                      },
                      hintText: 'Confirm New Password',
                      hintTextColor: Colors.white.withOpacity(0.6),
                      validator: (value) {
                        return PasswordValidationWidget
                            .validatePasswordOnPressed(value!);
                      },
                      controller: _.confirmPassword,
                      isTextHidden: _.securetext2,
                    ).marginOnly(left: 34, top: 15, right: 66),
                    SizedBox(
                      width: 150,
                      child: CommonButton(text: "Update Password", textStyle: TextStyle(
                          color: CommonColor.whiteColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Roboto'),
                       onPressed: () async {
                        if (_.formKey.currentState!.validate()) {
                          if (_.newPassword.text == _.confirmPassword.text) {
                            _.changePassword();
                          } else {
                            CustomSnackBar.showSnackBar(
                                title: AppStrings.passwordNotMatch,
                                message: "",
                                backgroundColor: CommonColor.snackbarColour,
                                isWarning: true);
                          }
                        }
                      },
                          fillColor: NewCommonColours.greenButton).marginOnly(top: 56),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
