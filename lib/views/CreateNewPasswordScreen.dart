// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/Controllers/createnewpassword_controller.dart';
import 'package:lytics_lens/widget/common_button/common_button.dart';
import 'package:lytics_lens/widget/common_textstyle/common_text_style.dart';
import 'package:lytics_lens/widget/form_validator/validator.dart';

import 'package:lytics_lens/widget/textFields/common_textfield.dart';

import '../Constants/app_strrings.dart';
import '../widget/snackbar/common_snackbar.dart';
// import 'package:resize/resize.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          // appBar: AppBar(
          //   backgroundColor: CommonColor.transparent,
          //   elevation: 0.0,
          //   leading: GestureDetector(
          //     onTap: () {
          //       Get.back();
          //     },
          //     child: Image.asset("assets/images/long_left.png"),
          //   ),
          // ),
          body: bodyData(context)),
    );
  }

  Widget bodyData(context) {
    return GetBuilder<CreatenewpasswordController>(
      init: CreatenewpasswordController(),
      builder: (_) {
        return SingleChildScrollView(
          child: Container(
            width: Get.width,
            height: Get.height,
            // decoration: const BoxDecoration(
            //   gradient: LinearGradient(
            //     // stops: [0.0, 1.0],
            //     // tileMode: TileMode.clamp,
            //     colors: [Color(0xff02083B), Color(0xff36E381)],
            //     begin: Alignment(1.0, -0.7),
            //     end: Alignment(3.0, 1.8),
            //     //stops: [0.8, 0.4],
            //     // begin: Alignment.topLeft,
            //     // end: Alignment.bottomRight
            //   ),
            // ),
            color: NewCommonColours.darkBackground,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    "Create New Password",
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        fontSize: 24.0,
                        letterSpacing: 0.4,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 26.0,
                ),
                Center(
                  child: SizedBox(
                    width: Get.width / 1.4,
                    height: 34,
                    //color: Colors.amber,
                    child: const Text(
                      "Your new password must be different\n from previously used passwords",
                      textScaleFactor: 1.0,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          color: Color(0xFFD3D3D3)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 43.0,
                ),
                Form(
                  key: _.formkey,
                  child: Column(
                    children: [
                      CommonTextField(

                        togglePassword: true,
                        disableBorderColor: NewCommonColours.darkTextfieldBorderColor,
                        bordercolor: NewCommonColours.borderColor,


                        isTextHidden: _.securetext,
                        fillcolor: NewCommonColours.darkTextfieldBorderColor,
                        controller: _.passwordController,
                        hintText: 'Enter New Password',
                        hintTextColor:
                            const Color(0xffffffff).withOpacity(0.43),
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
                        ],
                        toggleIcon: _.securetext == true
                            ? Icons.visibility_off_outlined
                            : Icons.remove_red_eye_outlined,
                        toggleFunction: () {
                          _.securetext = !_.securetext;
                          _.update();
                        },
                        //     ? Icons.visibility_off
                        //     : Icons.remove_red_eye,
                        // toggleFunction: () {
                        //   _.securetext = !_.securetext;
                        //   _.update();
                        // },
                        // ignore: body_might_complete_normally_nullable
                        validator: (value) {
                          return PasswordValidationWidget
                              .validatePasswordOnPressed(value!);
                        },
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      CommonTextField(

                        disableBorderColor: NewCommonColours.darkTextfieldBorderColor,
                        bordercolor: NewCommonColours.borderColor,
                        isTextHidden: _.securetext1,
                        togglePassword: true,

                        fillcolor: NewCommonColours.darkTextfieldBorderColor,
                        controller: _.retypePasswordController,
                        hintText: 'Confirm Password',
                        hintTextColor:
                          NewCommonColours.hintTextColor,

                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
                        ],
                        toggleIcon: _.securetext1 == true
                            ? Icons.visibility_off_outlined
                            : Icons.remove_red_eye_outlined,
                        toggleFunction: () {
                          _.securetext1 = !_.securetext1;
                          _.update();
                        },

                        //     ? Icons.visibility_off
                        //     : Icons.remove_red_eye,
                        // toggleFunction: () {
                        //   _.securetext1 = !_.securetext1;
                        //   _.update();
                        // },
                        // ignore: body_might_complete_normally_nullable
                        validator: (value) {
                          return PasswordValidationWidget
                              .validatePasswordOnPressed(value!);
                        },
                      ),
                    ],
                  ),
                ).marginOnly(left: 40.0, right: 40.0),
                const SizedBox(
                  height: 30,
                ),
                CommonButton(
                  fillColor: NewCommonColours.greenButton,
                  onPressed: () {
                    if (_.passwordController.text ==
                        _.retypePasswordController.text) {
                      _.createNewPassword();
                    } else {
                      CustomSnackBar.showSnackBar(
                        title: AppStrings.passwordmatcherror,
                        message: "",
                        backgroundColor: CommonColor.snackbarColour,
                        isWarning: true,
                      );
                    }
                  },
                  text: 'Save',
                  textStyle: NewTextStyle.font15,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
