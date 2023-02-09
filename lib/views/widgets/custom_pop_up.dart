import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_flutter_app/utils/themed_dialog.dart';
import 'package:weather_flutter_app/views/widgets/custom_button.dart';

class CustomAlertDialog extends StatelessWidget {
  final ButtonBuilder? buttonPositive;
  final ButtonBuilder? buttonNegative;
  final ButtonBuilder? buttonNeutral;
  final ButtonBuilder? buttonNeutral2;
  final String message;
  final String? title;
  final CustomAlertType type;
  final String? customImage;
  final Widget? customImageWidget;
  final double? imageSize;
  final double? buttonSpacing;
  final bool showCloseButton;

  CustomAlertDialog(
    this.message,
    this.type, {
    this.buttonPositive,
    this.title,
    this.buttonNegative,
    this.buttonNeutral,
    this.buttonNeutral2,
    this.customImage,
    this.imageSize,
    this.buttonSpacing,
    this.customImageWidget,
    this.showCloseButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return buttonNeutral2 == null
        ? Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: buildBody(),
          )
        : Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            insetPadding: EdgeInsets.all(4),
            child: buildBody(),
          );
  }

  Widget buildBody() {
    final buttonCount = [
      buttonNeutral2,
      buttonNeutral,
      buttonNegative,
      buttonPositive
    ].where((x) => x != null).length;
    final noButton = buttonCount == 0;
    return Builder(
      builder: (context) {
        return Container(
          width: 400,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: showCloseButton ? 0 : 20),
              !showCloseButton ? SizedBox() : Align(
                alignment: Alignment.centerRight,
                child: CustomCloseButton(),
              ),
              SizedBox(height: !showCloseButton ? 0 : 4),
              customImageWidget ?? SvgPicture.asset(
                getType(),
                width: imageSize ?? 60,
                height: imageSize ?? 60,
              ),
              SizedBox(height: 48),
              title == null
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12)
                          .copyWith(bottom: 18),
                      child: Text((title!).toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18
                          )),
                    ),
              Text(message,
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
              SizedBox(height: noButton ? 0 : buttonSpacing ?? 48),
              noButton
                  ? SizedBox()
                  : Row(
                      mainAxisAlignment: buttonNeutral == null
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            (buttonPositive == null)
                                ? Container()
                                : Expanded(
                                    child: generateButton(buttonPositive!)),
                            (buttonNegative == null)
                                ? Container()
                                : Expanded(
                                child: generateButton(buttonNegative!)),
                            (buttonNeutral == null)
                                ? Container()
                                : Expanded(
                                child: generateButton(buttonNeutral!)),
                            (buttonNeutral2 == null)
                                ? Container()
                                : Expanded(
                                child: generateButton(buttonNeutral2!)),
                          ],
                        )),
                      ],
                    )
            ],
          ),
        );
      },
    );
  }

  String getType() {
    switch (type) {
      case CustomAlertType.SUCCESS:
        return "assets/images/dialog/success.svg";
      case CustomAlertType.INFO:
        return "assets/images/dialog/info.svg";
      case CustomAlertType.WARNING:
        return "assets/images/dialog/warning.svg";
      case CustomAlertType.ERROR:
        return "assets/images/dialog/error.svg";
      case CustomAlertType.CUSTOM:
        return customImage!;
    }
  }

  Widget generateButton(ButtonBuilder button) {
    // SecondaryButton(text: text, onPressed: onPressed)
    switch (button.type) {
      case ButtonType.primary:
        return PrimaryButton(
          text: button.title,
          onPressed: button.onTap,
        );
      case ButtonType.secondary:
        return SecondaryButton(
          text: button.title,
          onPressed: button.onTap,
          textColor: button.textColor,
        );
      case ButtonType.link:
        return Builder(builder: (context) {
          return LinkButton(
            text: button.title,
            onPressed: button.onTap,
            textColor: Colors.white,
          );
        });
    }
  }

  Future show(BuildContext context)async{
    await showThemedDialog(context: context, builder: (_) => this);
  }
}

enum CustomAlertType { SUCCESS, INFO, WARNING, ERROR, CUSTOM }

class ButtonBuilder {
  final String title;
  final Function() onTap;
  final Color bgColor;

//  AppColors.primaryColor
  final Color textColor;
  final ButtonType type;

  ButtonBuilder(this.title, this.onTap, this.type,
      {this.bgColor = Colors.indigoAccent, this.textColor = Colors.black});
}

enum ButtonType {
  primary,
  secondary,
  link,
}

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(100),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.close,
          color: Colors.red,
        ),
      ),
    );
  }
}
