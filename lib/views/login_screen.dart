import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lytics_lens/Constants/common_color.dart';
import 'package:lytics_lens/Controllers/login_screen_controller.dart';
import 'package:lytics_lens/Views/Forgot%20Password.dart';
import 'package:lytics_lens/widget/common_button/common_button.dart';
import 'package:lytics_lens/widget/common_textstyle/common_text_style.dart';
import 'package:lytics_lens/widget/textFields/common_textfield.dart';
import 'package:lytics_lens/widget/snackbar/common_snackbar.dart';
import '../Constants/app_strrings.dart';
import '../widget/form_validator/validator.dart';
import '../widget/textFields/Global_TextField.dart';
import 'package:resize/resize.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(27, 29, 40, 1),
      body: bodyData(context),
    );
  }

  Widget bodyData(context) {
    return GetBuilder<LoginScreenController>(
      init: LoginScreenController(),
      builder: (_) {
        return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: _.isLoading
                ? Center(
                    child: Image.asset(
                      "assets/images/gif.gif",
                      height: 300.0,
                      width: 300.0,
                    ),
                  )
                : SingleChildScrollView(
                    child: Container(
                      width: Get.width,
                      height: Get.height,
                      //color: Colors.white,
                      decoration: const BoxDecoration(
                        // gradient: RadialGradient(
                        //   center: Alignment(1.0, 1.0),
                        //   radius: 1.0,
                        //   tileMode: TileMode.clamp,
                        //   colors: [Color(0xff22b161),Color(0xff000425)]
                        // )
                        gradient: LinearGradient(
                          // stops: [0.0, 1.0],
                          // tileMode: TileMode.clamp,
                          colors: [Color(0xff02083B), Color(0xff36E381)],
                          begin: Alignment(1.0, -0.7),
                          end: Alignment(3.0, 1.8),
                          //stops: [0.8, 0.4],
                          // begin: Alignment.topLeft,
                          // end: Alignment.bottomRight
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 50.0,
                                ),
                                Center(
                                  child: GestureDetector(
                                    onLongPress: () {
                                      _.eraseUrlStorage();
                                    },
                                    onDoubleTap: () {
                                      showBox(context, _);
                                    },
                                    child: Image.asset(
                                      "assets/images/new_logo.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ).marginSymmetric(horizontal: 25),
                                const SizedBox(
                                  height: 46.0,
                                ),
                                Form(
                                  key: _.formkey,
                                  child: Column(
                                    children: [
                                      CommonTextField(
                                        fillcolor:
                                            NewCommonColours.textFieldFillColor,
                                        controller: _.userNameController,
                                        disableBorderColor:
                                            NewCommonColours.disableBordorColor,
                                        bordercolor:
                                            NewCommonColours.borderColor,
                                        hintTextColor:
                                            NewCommonColours.hintTextColor,
                                        labelText: "Email",
                                        textInputAction: TextInputAction.next,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "This field is required";
                                          }
                                          Pattern pattern =
                                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                          var regex = RegExp(pattern as String);
                                          return (!regex.hasMatch(value))
                                              ? 'Please enter valid email'
                                              : null;
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(
                                              RegExp(r"\s\b|\b\s"))
                                        ],
                                        onChanged: (value) {
                                          value = value.replaceAll(' ', '');
                                        },
                                      ),
                                      const SizedBox(
                                        height: 18.0,
                                      ),
                                      CommonTextField(
                                        fillcolor:
                                            NewCommonColours.textFieldFillColor,
                                        controller: _.passwordController,
                                        textInputAction: TextInputAction.done,
                                        disableBorderColor:
                                            NewCommonColours.disableBordorColor,
                                        bordercolor:
                                            NewCommonColours.borderColor,

                                        //hintText: 'Password',
                                        labelText: "Password",
                                        hintTextColor:
                                            NewCommonColours.hintTextColor,
                                        isTextHidden: _.securetext,
                                        togglePassword: true,

                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(
                                              RegExp(r"\s\b|\b\s"))
                                        ],
                                        toggleIcon: _.securetext == true
                                            ? Icons.visibility_off_outlined
                                            : Icons.remove_red_eye_outlined,
                                        toggleFunction: () {
                                          _.securetext = !_.securetext;
                                          _.update();
                                        },
                                        validator: (value) {
                                          return PasswordEmptyValidate
                                              .validateEmptyPassword(value!);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                CommonButton(
                                  width: Get.width / 3,
                                  text: "Login",
                                  textStyle: NewTextStyle.font15,
                                  fillColor: NewCommonColours.greenButton,
                                  onPressed: () async {
                                    await _.verifyEmailPassword();
                                  },
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => const ForgotPassword());
                                    },
                                    child: const Text(
                                      "Forgot Password?",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          color: CommonColor.nTextColor,
                                          letterSpacing: 0.4,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 60.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _.checkBio();
                                  },
                                  child: Image.asset(
                                    "assets/images/fingerprint.png",
                                    height: 50.0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _.checkBio();
                                  },
                                  child: const Text(
                                    "Use Biometric",
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14,
                                        letterSpacing: 0.17),
                                  ),
                                ),
                              ],
                            ).marginOnly(left: 50.0, right: 50.0),
                          ),
                          const Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              AppStrings.version,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  fontSize: 11.0,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          ).marginOnly(bottom: 20.0)
                        ],
                      ),
                    ),
                  ));
      },
    );
  }

  showBox(context, LoginScreenController _) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CommonColor.backgroundColour,
        title: const Text(
          'ENTER URL',
          textScaleFactor: 1.0,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white38,
          ),
        ),
        content: SizedBox(
          height: 150,
          child: Column(
            children: [
              GlobalTextField(_.linkController, (value) {
                if (value.isEmpty) return "Enter link";
              }, "110.93.212.132:3000", TextInputAction.done, false),
              const SizedBox(
                height: 10.0,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.0),
                  side: const BorderSide(color: NewCommonColours.greenButton),
                ),
                onPressed: () async {
                  if (_.linkController.text.isEmpty ||
                      _.linkController.text == "") {
                    CustomSnackBar.showSnackBar(
                        title: "Please add URL",
                        message: "",
                        backgroundColor: CommonColor.snackbarColour,
                        isWarning: true);
                  } else {
                    await _.getUrl();
                  }
                },
                minWidth: 274.w,
                height: 36.h,
                color: NewCommonColours.greenButton,
                child: Text(
                  "Done",
                  textScaleFactor: 1.0,
                  style:
                      TextStyle(color: CommonColor.whiteColor, fontSize: 11.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
