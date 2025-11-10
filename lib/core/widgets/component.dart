import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms/core/constants/image_utils.dart';

import '../../main.dart';
import '../constants/color_utils.dart';
import '../constants/string_utils.dart';

AppBar commonAppBar({
  required final String title,
  final bool? centerTitle,
  final List<Widget>? actions,
  final Widget? leading,
  final Color? backgroundColor,
  required final BuildContext context,
  final IconThemeData? iconTheme,
  final List<Color>? gradientColors,
}) {
  return AppBar(
    surfaceTintColor: Colors.transparent,
    iconTheme: iconTheme,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
    ),
    title: Text(
      title.toUpperCase(),
      style: commonTextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    centerTitle: centerTitle,
    backgroundColor: backgroundColor ?? colorProduct,
    // important
    elevation: 0,
    actions: actions,
    leading:
        leading ??
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_sharp, color: Colors.white),
        ),
    flexibleSpace: Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorProduct,
        borderRadius: BorderRadius.circular(0),
      ),
    ),
  );
}

Column commonTextFieldView({
  String? text,
  String? hint,
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? initialValue,
  TextInputType? keyboardType,
  bool readOnly = false,
  bool? obscureText,
  void Function()? onTap,
  String? Function(String?)? validator,
  List<TextInputFormatter>? inputFormatters,
  TextEditingController? controller,
  int? maxLines,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 8,
    children: [
      commonText(text: text ?? "Email Id", fontSize: 13),
      commonTextField(
        onTap: onTap,
        validator: validator,
        controller: controller,
        maxLines: maxLines ?? 1,
        readOnly: readOnly,
        textStyle: commonTextStyle(fontSize: 13),
        hintStyle: commonTextStyle(fontSize: 13),
        inputFormatters: inputFormatters,
        keyboardType: keyboardType ?? TextInputType.text,
        initialValue: initialValue,
        obscureText: obscureText ?? false,
        hintText: '',
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    ],
  );
}

InkWell commonInkWell({Widget? child, void Function()? onTap}) {
  return InkWell(
    splashColor: Colors.transparent,
    focusNode: FocusNode(skipTraversal: true),
    highlightColor: Colors.transparent,

    onTap: onTap,
    child: child,
  );
}

Widget commonText({
  required String text,
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  String? fontFamily,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
  TextStyle? style,
  TextDecoration? decoration,
}) {
  return Text(
    text,
    textAlign: textAlign,

    maxLines: maxLines,
    overflow: overflow,
    style:
        style ??
        commonTextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          decoration: decoration,
        ),
  );
}

TextStyle commonTextStyle({
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  double? wordSpacing,
  double? letterSpacing,
  String? fontFamily,
  FontStyle? fontStyle,
  Color? decorationColor,
  TextOverflow? overflow,
  TextDecoration? decoration,
}) {
  return TextStyle(
    color: color ?? Colors.black,
    fontSize: fontSize ?? 14,
    wordSpacing: wordSpacing,
    decoration: decoration,
    overflow: overflow,
    fontFamily: fontFamily ?? fontRoboto,
    decorationColor: decorationColor,
    letterSpacing: letterSpacing,
    fontStyle: fontStyle ?? FontStyle.normal,

    fontWeight: fontWeight ?? FontWeight.w400,
  );
}

BoxDecoration commonBoxDecoration({
  Color color = Colors.transparent,
  double borderRadius = 8.0,
  Color borderColor = Colors.transparent,
  double borderWidth = 1.0,

  Gradient? gradient,
  DecorationImage? image,
  BoxShape shape = BoxShape.rectangle,
}) {
  return BoxDecoration(
    color: color,
    shape: shape,
    image: image,
    borderRadius: shape == BoxShape.rectangle
        ? BorderRadius.circular(borderRadius)
        : null,
    border: Border.all(color: borderColor, width: borderWidth),

    gradient: gradient,
  );
}

Widget commonButton({
  required final String text,
  required final VoidCallback onPressed,
  final Color? color,
  final Color? textColor,
  final Color? colorBorder,
  final double? radius,
  final double? height,
  final double? width,
  final double? fontSize,
  final FontWeight? fontWeight,
  final Widget? icon,

  final EdgeInsetsGeometry? padding,
}) {
  return SizedBox(
    height: height ?? 56,
    width: width ?? MediaQuery.sizeOf(navigatorKey.currentContext!).width,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? colorProduct,

        borderRadius: BorderRadius.circular(radius ?? 15),
      ),
      child: ElevatedButton(
        style:
            ElevatedButton.styleFrom(
              elevation: 0,
              disabledIconColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              disabledForegroundColor: Colors.transparent,
              backgroundColor: color ?? Colors.transparent,
              foregroundColor: Colors.transparent,
              overlayColor: Colors.transparent,
              // 👈 click effect hide
              shadowColor: Colors.transparent,
              // 👈 shadow bhi hide
              shape: RoundedRectangleBorder(
                side: BorderSide(color: colorBorder ?? Colors.transparent),
                borderRadius: BorderRadius.circular(radius ?? 15),
              ),
              padding: padding,
            ).copyWith(
              overlayColor: WidgetStateProperty.all(
                Colors.transparent,
              ), // 👈 pressed color hide
            ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            commonText(
              color: textColor ?? Colors.white,
              text: text.toUpperCase(),
              fontSize: fontSize,
              // color: provider.isDark?colorDarkBgColor:Colors.white,
              fontWeight: fontWeight ?? FontWeight.w600,
            ),
            icon ?? const SizedBox.shrink(),
          ],
        ),
      ),
    ),
  );
}

Widget commonTextField({
  TextEditingController? controller,
  required String hintText,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
  Widget? prefixIcon,
  bool? enabled,
  Widget? suffixIcon,
  String? Function(String?)? validator,
  EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  ),
  Color? borderColor,
  double borderRadius = 12.0,
  Color? fillColor,
  int? maxLines,
  bool filled = false,
  void Function()? onTap,
  bool readOnly = false,
  TextStyle? hintStyle,
  InputBorder? enabledBorder,
  String? initialValue,
  void Function(String)? onChanged,
  List<TextInputFormatter>? inputFormatters,
  TextStyle? textStyle,
}) {
  return TextFormField(
    enabled: enabled,
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    validator: validator,
    initialValue: controller != null ? null : initialValue ?? '',
    //initialValue: initialValue
    maxLines: maxLines,
    readOnly: readOnly,
    onTap: onTap,
    autocorrect: false,
    onChanged: onChanged,
    inputFormatters: inputFormatters,
    style: textStyle ?? commonTextStyle(fontSize: 14),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: hintStyle ?? commonTextStyle(),
      contentPadding: contentPadding,

      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border:
          enabledBorder ?? commonTextFiledBorder(borderRadius: borderRadius),
      enabledBorder:
          enabledBorder ?? commonTextFiledBorder(borderRadius: borderRadius),
      focusedBorder:
          enabledBorder ?? commonTextFiledBorder(borderRadius: borderRadius),
      filled: filled,
      fillColor: fillColor,
    ),
  );
}

OutlineInputBorder commonTextFiledBorder({
  double? borderRadius,
  Color? borderColor,
}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius ?? 15),
    borderSide: BorderSide(
      color: borderColor ?? Colors.grey.withValues(alpha: 0.5),
    ),
  );
}

Widget commonScaffold({
  required Widget body,
  String? title,
  PreferredSizeWidget? appBar,
  Widget? floatingActionButton,
  Widget? drawer,
  Widget? bottomNavigationBar,
  Color backgroundColor = Colors.white,
  bool resizeToAvoidBottomInset = true,
}) {
  return Scaffold(
    appBar:
        appBar ??
        (title != null
            ? AppBar(title: commonText(text: title), centerTitle: true)
            : null),
    body: body,
    backgroundColor: backgroundColor,
    floatingActionButton: floatingActionButton,
    drawer: drawer,
    bottomNavigationBar: bottomNavigationBar,
    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
  );
}

Widget commonAssetImage(
  String path, {
  double? width,
  double? height,
  BoxFit? fit,
  BorderRadius? borderRadius,
  Color? color,
}) {
  Widget image = Image.asset(
    path,
    width: width,
    height: height,
    fit: fit,
    color: color,
  );

  return borderRadius != null
      ? ClipRRect(borderRadius: borderRadius, child: image)
      : image;
}

Widget commonCircleAssetImage(
  String path, {
  double size = 60,
  BoxFit fit = BoxFit.cover,
  Color? backgroundColor = Colors.transparent,
  Color? borderColor,
  double borderWidth = 0,
}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: backgroundColor,
      border: borderColor != null
          ? Border.all(color: borderColor, width: borderWidth)
          : null,
      image: DecorationImage(image: AssetImage(path), fit: fit),
    ),
  );
}

Widget showLoaderList1() {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorLogo, colorLogo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(17),
      child: const CupertinoActivityIndicator(
        radius: 15,
        color: Colors.white,
        animating: true,
      ),
    ),
  );
}

List<TextInputFormatter> onlyNumberFormatter() {
  return [FilteringTextInputFormatter.digitsOnly];
}

PopScope<Object> commonPopScope({
  required final Widget child,
  final VoidCallback? onBack,
}) {
  return PopScope(
    canPop: true,
    onPopInvokedWithResult: (didPop, result) {
      if (didPop && onBack != null) {
        onBack();
      }
    },
    child: child,
  );
}

Center commonErrorView({String? text}) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 20,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //commonAssetImage(icNoData, width: 100, height: 100),
        commonText(
          textAlign: TextAlign.center,
          text: text ?? '',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black.withValues(alpha: 0.5),
        ),
      ],
    ),
  );
}

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

Future<bool?> showCommonDialog({
  required String title,
  required BuildContext context,
  String? content,
  String confirmText = 'OK',
  bool? barrierDismissible,
  String cancelText = 'Cancel',
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  void Function()? onPressed,
  List<Widget>? actions,
  Widget? contentView,
  bool showCancel = true,
}) {
  return showCupertinoDialog<bool>(
    barrierDismissible: barrierDismissible ?? false,
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: commonText(
          text: title,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        content:
            contentView ??
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: commonText(
                text: content ?? '',
                textAlign: TextAlign.center,
                fontSize: 12,
              ),
            ),
        actions:
            actions ??
            <Widget>[
              if (showCancel)
                CupertinoDialogAction(
                  isDefaultAction: false,
                  onPressed: () {
                    onCancel?.call();
                    Navigator.of(context).pop(false); // return false
                  },
                  child: commonText(
                    text: cancelText.toUpperCase(),
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed:
                    onPressed ??
                    () {
                      onConfirm?.call();
                      Navigator.of(context).pop(true); // return true
                    },
                child: commonText(
                  text: confirmText.toUpperCase(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
      );
    },
  );
}

Widget showLoaderList() {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [colorProduct, colorProduct],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(17),
      child: SizedBox(
        height: 40,
        width: 40,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      ),
    ),
  );
}

String cleanFirebaseError(String message) {
  return message.replaceAll(RegExp(r"\[.*?\]\s*"), "");
}

Container commonAppBackground({required Widget child, Color? color}) {
  var size = MediaQuery.of(navigatorKey.currentContext!).size;

  return Container(
    width: size.width,
    height: size.height,
    decoration: commonBoxDecoration(
      borderRadius: 0,
      color: color ?? Colors.white,
      //image: DecorationImage(fit: BoxFit.fill, image: AssetImage(icSa)),
    ),
    child: child,
  );
}

Widget commonSubTitleText({String? text}) {
  return commonText(
    text: text ?? '',
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );
}

Widget commonPrefixIcon({
  required String image,
  double? width,
  double? height,
  Color? colorIcon,
}) {
  return SizedBox(
    width: width ?? 24,
    height: height ?? 24,
    child: Center(
      child: commonAssetImage(
        image,
        width: width ?? 24,
        height: height ?? 24,
        color: colorIcon ?? Colors.grey,
      ),
    ),
  );
}

class BottomNavItems {
  static const List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage(icMenuKPI)),
      label: myKAP,
    ),
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage(icMenuCalender)),
      label: calendar,
    ),

    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage(icMenuHome)),
      label: home,
    ),

    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage(icMenuAttendance)),
      label: attendance,
    ),
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage(icSetting)),
      label: setting,
    ),
  ];
}

Widget commonRefreshIndicator({
  required final Future<void> Function() onRefresh,
  required final Widget child,
}) {
  return RefreshIndicator(
    color: colorLogo,
    backgroundColor: Colors.white,
    strokeWidth: 2,
    onRefresh: onRefresh,
    child: child,
  );
}

Widget commonBoxView({required Widget contentView, required String title,double ?fontSize}) {
  return Container(
    decoration: commonBoxDecoration(
      color: colorProduct.withValues(alpha: 0.01),
      borderColor: colorBorder,
      borderRadius: 8,
    ),
    margin: const EdgeInsets.all(0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        commonHeadingView(title: title,fontSize: fontSize),

        const Divider(height: 0.5, color: colorBorder),

        // Content
        Padding(padding: const EdgeInsets.all(12.0), child: contentView),
      ],
    ),
  );
}

Widget commonRowLeftRightView({
  required String title,
  String? value,
  Widget? customView,
}) {
  return Row(
    children: [
      Expanded(
        child: commonText(
          text: title,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
      Expanded(
        child:
            customView ??
            commonText(
              text: value ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
      ),
    ],
  );
}

Widget commonHeadingView({String? title,double ? fontSize}) {
  return Padding(
    padding: EdgeInsets.all(12.0),
    child: Row(
      children: [
        Expanded(
          child: commonText(
            color: colorProduct,
            text: title ?? "Product Information",
            fontSize:fontSize?? 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

void showToast(String message) {
  ScaffoldMessenger.of(
    navigatorKey.currentContext!,
  ).showSnackBar(SnackBar(content: Text(message)));
}

Widget commonPasswordFieldView({
  required String text,
  required TextEditingController controller,
  required bool obscureText,
  required VoidCallback onToggle,
  FormFieldValidator<String>? validator,
  Widget? prefixIcon,
}) {
  return commonTextField(
    controller: controller,
    maxLines: 1,
    hintText: text,
    obscureText: obscureText,
    keyboardType: TextInputType.visiblePassword,
    validator: validator,
/*    decoration: InputDecoration(
      labelText: text,
      prefixIcon: prefixIcon,
      suffixIcon: IconButton(
        icon: Icon(
          obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: onToggle,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),*/
  );
}

void showCommonBottomSheet({
  required BuildContext context,
  required Widget content,

  bool isDismissible = true,
}) {

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor:  Colors.white,
    isDismissible: isDismissible,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: content,
      );
    },
  );
}
