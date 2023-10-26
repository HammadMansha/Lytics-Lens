// ignore_for_file: file_names

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lytics_lens/Constants/app_strrings.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/Controllers/forgotpassword_controller.dart';
import 'package:lytics_lens/widget/common_button/common_button.dart';
import 'package:lytics_lens/widget/common_textstyle/common_text_style.dart';
import 'package:lytics_lens/widget/textFields/common_textfield.dart';
import 'package:lytics_lens/views/CreateNewPasswordScreen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../widget/snackbar/common_snackbar.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
      init: ForgotPasswordController(),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Image.asset("assets/images/long_left.png"),
            ),
            backgroundColor:NewCommonColours.darkBackground,
          ),
          body: Container(
            height: Get.height,
            width: Get.width,
            color: NewCommonColours.darkBackground,
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
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Forgot Your Password?",
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                letterSpacing: 0.7,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Roboto'),
                            textAlign: TextAlign.center),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Center(
                          child: SizedBox(
                            width: Get.width / 1.3,
                            height: 32,
                            child: const Text(
                              "Enter your registered email below to receive password reset instructions",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  letterSpacing: 0.4,
                                  color: Color(0xFFD3D3D3),
                                  fontSize: 12.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 43.0,
                        ),
                        Form(
                          key: _.formkey,
                          child: CommonTextField(
                            fillcolor: NewCommonColours.DarkTextfieldColor,
                            disableBorderColor: NewCommonColours.darkTextfieldBorderColor,
                            bordercolor: NewCommonColours.borderColor,
                            controller: _.emailController,
                            hintText: 'Email Address',
                            hintTextColor:
                               NewCommonColours.hintTextColor,
                            textInputAction: TextInputAction.next,
                            // ignore: body_might_complete_normally_nullable
                            validator: (value) {
                              if (value!.isEmpty) return "Enter email";
                              if (EmailValidator.validate(
                                      _.emailController.text) ==
                                  false) return "Enter valid email";
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 34.0,
                        ),
                        CommonButton(
                          fillColor: NewCommonColours.greenButton,
                          onPressed: () {
                            if (_.start == 0 || _.start == 60) {
                              _.forgotPassword();
                            }
                          },
                          text: 'Send Code',
                          textStyle: NewTextStyle.font15,
                        ),
                        const SizedBox(
                          height: 38.0,
                        ),
                        SizedBox(
                          width: Get.width / 1.8,
                          child: PinCodeTextField(
                            appContext: context,
                            pastedTextStyle: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 11),
                            length: 4,
                            animationType: AnimationType.fade,
                            textStyle: GoogleFonts.roboto(
                                letterSpacing: 0.4,
                                color: Colors.white,
                                fontSize: 11),
                            // ignore: body_might_complete_normally_nullable
                            validator: (v) {
                              // if (v!.length < 3) {
                              //   return "I'm from validator";
                              // } else {
                              //   return null;
                              // }
                            },
                            pinTheme: PinTheme(
                              selectedFillColor: NewCommonColours.darkTextfieldBorderColor,
                              selectedColor: NewCommonColours.borderColor,
                              borderWidth: 2,
                              disabledColor: NewCommonColours.darkTextfieldBorderColor,
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(4),
                              fieldHeight: 46,
                              fieldWidth: 46,
                              inactiveColor:
                              NewCommonColours.darkTextfieldBorderColor,
                              inactiveFillColor:
                              NewCommonColours.darkTextfieldBorderColor,
                              activeColor:
                              NewCommonColours.borderColor,
                              activeFillColor:
                              NewCommonColours.darkTextfieldBorderColor,
                            ),
                            cursorColor: CommonColor.snackbarColour,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            enableActiveFill: true,
                            errorAnimationController: _.errorController,
                            controller: _.pin,
                            keyboardType: TextInputType.number,
                            boxShadows: const [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black12,
                                blurRadius: 10,
                              )
                            ],
                            onCompleted: (v) {
                              if (_.start == 60 || _.start == 0) {
                                CustomSnackBar.showSnackBar(
                                    title: 'OTP code has expired please retry',
                                    message: "",
                                    backgroundColor: CommonColor.snackbarColour,
                                    isWarning: true);
                              } else {
                                if (v.toString() == _.lastcode.toString()) {
                                  _.start = 0;
                                  _.update();

                                  Get.to(() => const CreateNewPasswordScreen(),
                                      arguments: _.emailController.text);
                                } else {
                                  CustomSnackBar.showSnackBar(
                                      title: AppStrings.otpNotMatch,
                                      message: "",
                                      backgroundColor:
                                          CommonColor.snackbarColour,
                                      isWarning: true);
                                }
                              }
                            },
                            onChanged: (value) {},
                            beforeTextPaste: (text) {
                              return true;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 35.0,
                        ),
                        const Center(
                          child: Text(
                            'ENTER CODE',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                              fontSize: 12.0,
                              letterSpacing: 0.4,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 19.0,
                        ),
                        Center(
                          child: Text(
                            '00 : ${_.start}',
                            textScaleFactor: 1.0,
                            style: GoogleFonts.roboto(
                              fontSize: 18.0,
                              letterSpacing: 0.4,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ).marginOnly(left: 55.0, right: 30.0),
              ),
            ),
          ),
        );
      },
    );
  }
}
