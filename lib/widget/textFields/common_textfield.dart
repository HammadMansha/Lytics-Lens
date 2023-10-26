import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lytics_lens/Constants/common_color.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? labelText;
  final Color? fillcolor;
  final Color? bordercolor;
  final Color? disableBorderColor;

  final bool isTextHidden;
  final String? hintText;
  final IconData? buttonIcon;
  final IconData? prefixIcon;
  final bool? togglePassword;
  final int? maxLength;
  final int maxLine;
  final Function()? toggleFunction;
  final IconData? toggleIcon;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final Function()? onTap;
  final Function()? prefixIconTap;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focus;
  final TextInputAction? textInputAction;
  final Color? hintTextColor;
  final bool isInlineBorder;

  const CommonTextField(
      {Key? key,
      @required this.controller,
      this.validator,
      this.bordercolor,
        this.disableBorderColor,
      this.labelText,
      this.fillcolor,
      this.hintText,
      this.isTextHidden = false,
      this.buttonIcon,
      this.prefixIcon,
      this.onChanged,
      this.togglePassword = false,
      this.toggleFunction,
      this.toggleIcon,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.maxLength,
      this.maxLine = 1,
      this.readOnly,
      this.onTap,
      this.inputFormatters,
      this.prefixIconTap,
      this.hintTextColor,
      this.focus,
      this.isInlineBorder = false,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final mqDataNew = mqData.copyWith(
        textScaleFactor:
            mqData.textScaleFactor > 1.0 ? 1.0 : mqData.textScaleFactor);
    return MediaQuery(
      data: mqDataNew,
      child: TextFormField(
        cursorColor: const Color(0xff2CE08E),
        textAlignVertical: TextAlignVertical.center,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        obscureText: isTextHidden,
        readOnly: readOnly == null ? false : true,
        onTap: onTap,
        maxLength: maxLength,
        maxLines: maxLine,
        focusNode: focus,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          errorStyle: const TextStyle(
            fontSize: 10.0,
          ),
          prefixIcon: prefixIcon != null
              ? GestureDetector(
                  onTap: prefixIconTap,
                  child: Icon(
                    prefixIcon,
                    color: Colors.black,
                    size: 20.0,
                  ),
                )
              : null,
          suffixIcon: togglePassword!
              ? GestureDetector(
                  onTap: toggleFunction,
                  child: Icon(
                    toggleIcon,
                    color: Colors.white,
                  ))
              : null,

          //-----------------Without Onpress text field border Colour-----------
          enabledBorder: isInlineBorder ? UnderlineInputBorder(
              borderSide: BorderSide(
                color: disableBorderColor?? NewCommonColours.clippingBorderColor,
              )
          ) : OutlineInputBorder(
            borderSide: BorderSide(
              color: disableBorderColor?? NewCommonColours.clippingBorderColor,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          focusedBorder: isInlineBorder ? UnderlineInputBorder(
              borderSide: BorderSide(
                color: bordercolor ??NewCommonColours.clippingBorderColor,
              )
          ) : OutlineInputBorder(
            borderSide: BorderSide(
              color: bordercolor ?? NewCommonColours.clippingBorderColor,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          hintText: hintText,
          fillColor: fillcolor ?? const Color.fromRGBO(45, 47, 58, 1),
          filled: true,
          helperStyle: TextStyle(
            letterSpacing: 0.4,
            color: hintTextColor ?? Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w300,
          ),
          hintStyle: TextStyle(
              letterSpacing: 0.4,
              color: hintTextColor ?? Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w400),
          contentPadding: const EdgeInsets.all(10.0),
          labelText: labelText,
          labelStyle:  TextStyle(
              letterSpacing: 0.4,
              color: Colors.white.withOpacity(0.43),
              fontSize: 13.0,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400),
          border: isInlineBorder ? const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(5.0))
          ) : const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
        style: const TextStyle(
            letterSpacing: 0.4,
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w400),
        controller: controller,
        validator: validator,
      ),
    );
  }
}

class CommonTextField1 extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? labelText;
  final Color? fillcolor;
  final Color? bordercolor;
  final bool isTextHidden;
  final String? hintText;
  final IconData? buttonIcon;
  final IconData? prefixIcon;
  final bool? togglePassword;
  final int? maxLength;
  final Function()? toggleFunction;
  final IconData? toggleIcon;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final Function()? onTap;
  final Function()? prefixIconTap;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focus;
  final TextInputAction? textInputAction;

  const CommonTextField1(
      {Key? key,
      @required this.controller,
      this.validator,
      this.bordercolor,
      this.labelText,
      this.fillcolor,
      this.hintText,
      this.isTextHidden = false,
      this.buttonIcon,
      this.prefixIcon,
      this.onChanged,
      this.togglePassword = false,
      this.toggleFunction,
      this.toggleIcon,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.maxLength,
      this.readOnly,
      this.onTap,
      this.inputFormatters,
      this.prefixIconTap,
      this.focus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: const Color(0xff2CE08E),
      textAlignVertical: TextAlignVertical.center,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      obscureText: isTextHidden,
      readOnly: readOnly == null ? false : true,
      onTap: onTap,
      maxLength: maxLength,
      focusNode: focus,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null
            ? GestureDetector(
                onTap: prefixIconTap,
                child: Icon(
                  prefixIcon,
                  color: Colors.black,
                  size: 20.0,
                ),
              )
            : null,
        suffixIcon: togglePassword!
            ? GestureDetector(
                onTap: toggleFunction,
                child: Icon(
                  toggleIcon,
                  color: const Color(0xff504f51),
                ))
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: bordercolor ?? Colors.transparent,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: bordercolor ?? Colors.transparent,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(3),
          ),
        ),
        hintText: hintText,
        //fillColor: fillcolor ?? const Color.fromRGBO(45, 47, 58, 1),
        //filled: true,
        hintStyle: const TextStyle(
            letterSpacing: 0.4,
            color: Colors.white38,
            fontSize: 14.0,
            fontWeight: FontWeight.w400),
        contentPadding: const EdgeInsets.only(
          left: 10,
          top: 16,
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
            letterSpacing: 0.4, color: Colors.black, fontSize: 10.0),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffB7B7B7)),
          borderRadius: BorderRadius.all(Radius.circular(3.0)),
        ),
      ),
      style: const TextStyle(
          letterSpacing: 0.4,
          color: Colors.white,
          fontSize: 14.0,
          fontWeight: FontWeight.w400),
      controller: controller,
      validator: validator,
    );
  }
}

class CommonTextField2 extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? labelText;
  final Color? fillcolor;
  final Color? bordercolor;
  final bool isTextHidden;
  final String? hintText;
  final IconData? buttonIcon;
  final IconData? prefixIcon;
  final bool? togglePassword;
  final int? maxLength;
  final Function()? toggleFunction;
  final IconData? toggleIcon;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final Function()? onTap;
  final Function()? prefixIconTap;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focus;
  final TextInputAction? textInputAction;

  const CommonTextField2(
      {Key? key,
      @required this.controller,
      this.validator,
      this.bordercolor,
      this.labelText,
      this.fillcolor,
      this.hintText,
      this.isTextHidden = false,
      this.buttonIcon,
      this.prefixIcon,
      this.onChanged,
      this.togglePassword = true,
      this.toggleFunction,
      this.toggleIcon,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.maxLength,
      this.readOnly,
      this.onTap,
      this.inputFormatters,
      this.prefixIconTap,
      this.focus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final mqDataNew = mqData.copyWith(
        textScaleFactor:
            mqData.textScaleFactor > 1.0 ? 1.0 : mqData.textScaleFactor);
    return MediaQuery(
      data: mqDataNew,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        obscureText: isTextHidden,
        readOnly: readOnly == null ? false : true,
        onTap: onTap,
        maxLength: maxLength,
        focusNode: focus,
        keyboardType: keyboardType,
        cursorColor: const Color(0xff2CE08E),
        textInputAction: textInputAction,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xff22B161),
            size: 25,
          ),
          // suffix: Padding(
          //   padding: const EdgeInsets.only(bottom:6),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     children: [
          //       MaterialButton(
          //         onPressed: (){},
          //         child: Text("ADD",style: TextStyle(color: Colors.white),),
          //         color: Colors.black,
          //         height: 38,
          //         minWidth: 33,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(9.0),
          //         ),
          //
          //       ),
          //     ],
          //   ),
          // ),

          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: bordercolor ?? Colors.transparent,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(13),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: bordercolor ?? Colors.transparent,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          hintText: hintText,
          filled: true,
          fillColor: fillcolor,
          hintStyle: const TextStyle(
              letterSpacing: 0.4,
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w400),
          contentPadding: const EdgeInsets.all(10.0),
          labelText: labelText,
          labelStyle: const TextStyle(
              letterSpacing: 0.4, color: Colors.black, fontSize: 10.0),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
        style: const TextStyle(
            color: Colors.white,
            letterSpacing: 0.4,
            fontSize: 14.0,
            fontWeight: FontWeight.w400),
        controller: controller,
        validator: validator,
      ),
    );
  }
}

class CommonTextField3 extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? labelText;
  final Color? fillcolor;
  final Color? bordercolor;
  final bool isTextHidden;
  final String? hintText;
  final IconData? buttonIcon;
  final IconData? prefixIcon;
  final bool? togglePassword;
  final int? maxLength;
  final Function()? toggleFunction;
  final IconData? toggleIcon;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final Function()? onTap;
  final Function()? prefixIconTap;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focus;
  final TextInputAction? textInputAction;

  const CommonTextField3(
      {Key? key,
      @required this.controller,
      this.validator,
      this.bordercolor,
      this.labelText,
      this.fillcolor,
      this.hintText,
      this.isTextHidden = false,
      this.buttonIcon,
      this.prefixIcon,
      this.onChanged,
      this.togglePassword = false,
      this.toggleFunction,
      this.toggleIcon,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.maxLength,
      this.readOnly,
      this.onTap,
      this.inputFormatters,
      this.prefixIconTap,
      this.focus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final mqDataNew = mqData.copyWith(
        textScaleFactor:
            mqData.textScaleFactor > 1.0 ? 1.0 : mqData.textScaleFactor);
    return MediaQuery(
      data: mqDataNew,
      child: SizedBox(
        height: 38.0,
        child: TextFormField(
          cursorColor: const Color(0xff22B161),
          textAlignVertical: TextAlignVertical.center,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          obscureText: isTextHidden,
          readOnly: readOnly == null ? false : true,
          onTap: onTap,
          maxLength: maxLength,
          focusNode: focus,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              color: CommonColor.gradientColor,
              size: 22,
            ),
            suffixIcon: togglePassword!
                ? GestureDetector(
                    onTap: toggleFunction,
                    child: Icon(
                      toggleIcon,
                      color: const Color(0xff504f51),
                    ))
                : null,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: bordercolor ?? Colors.transparent,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(19),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: bordercolor ?? Colors.transparent,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(19),
              ),
            ),
            hintText: hintText,
            fillColor: fillcolor ?? const Color.fromRGBO(45, 47, 58, 1),
            filled: true,
            hintStyle: const TextStyle(
                letterSpacing: 0.4,
                color: Color(0xffb9b9b9),
                fontSize: 13.0,
                fontWeight: FontWeight.w400),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            labelText: labelText,
            labelStyle: const TextStyle(
                letterSpacing: 0.4, color: Colors.black, fontSize: 10.0),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          style: const TextStyle(
              letterSpacing: 0.4,
              color: Colors.black,
              fontSize: 13.0,
              fontWeight: FontWeight.w400),
          controller: controller,
          validator: validator,
        ),
      ),
    );
  }
}

class CommonTextField4 extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? labelText;
  final Color? fillcolor;
  final Color? bordercolor;
  final bool isTextHidden;
  final String? hintText;
  final IconData? buttonIcon;
  final IconData? prefixIcon;
  final bool? togglePassword;
  final int? maxLength;
  final Function()? toggleFunction;
  final IconData? toggleIcon;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final Function()? onTap;
  final Function()? prefixIconTap;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focus;
  final TextInputAction? textInputAction;

  const CommonTextField4(
      {Key? key,
      @required this.controller,
      this.validator,
      this.bordercolor,
      this.labelText,
      this.fillcolor,
      this.hintText,
      this.isTextHidden = false,
      this.buttonIcon,
      this.prefixIcon,
      this.onChanged,
      this.togglePassword = false,
      this.toggleFunction,
      this.toggleIcon,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.maxLength,
      this.readOnly,
      this.onTap,
      this.inputFormatters,
      this.prefixIconTap,
      this.focus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final mqDataNew = mqData.copyWith(
        textScaleFactor:
            mqData.textScaleFactor > 1.0 ? 1.0 : mqData.textScaleFactor);
    return MediaQuery(
      data: mqDataNew,
      child: SizedBox(
        height: 38.0,
        child: TextFormField(
          textAlign: TextAlign.right,
          cursorColor: const Color(0xff22B161),
          enableInteractiveSelection: false,
          toolbarOptions: const ToolbarOptions(
            copy: false,
            paste: false,
            cut: false,
            selectAll: false,
          ),
          textDirection: TextDirection.rtl,
          // textAlignVertical: TextAlignVertical.center,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          obscureText: isTextHidden,
          readOnly: readOnly == null ? false : true,
          onTap: onTap,
          maxLength: maxLength,
          focusNode: focus,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            suffixIcon: const Icon(
              Icons.search,
              color: CommonColor.greenColor,
              size: 22,
            ),
            // suffixIcon: Padding(
            //     padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            //     child: Icon(
            //       Icons.search,
            //       color: Color(0xff22B161),
            //       size: 25,
            //     )),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: bordercolor ?? Colors.transparent,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(19),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: bordercolor ?? Colors.transparent,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(19),
              ),
            ),
            hintText: hintText,
            fillColor: fillcolor ?? const Color.fromRGBO(45, 47, 58, 1),
            filled: true,
            hintStyle: const TextStyle(
                letterSpacing: 0.4,
                color: Color(0xffb9b9b9),
                fontSize: 13.0,
                fontWeight: FontWeight.w400),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            labelText: labelText,
            labelStyle: const TextStyle(
                letterSpacing: 0.4, color: Colors.black, fontSize: 10.0),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          style: const TextStyle(
              letterSpacing: 0.4,
              color: Colors.black,
              fontSize: 13.0,
              fontWeight: FontWeight.w400),
          controller: controller,
          validator: validator,
        ),
      ),
    );
  }
}
