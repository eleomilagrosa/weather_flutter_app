
import 'package:flutter/material.dart';

import 'progress_button.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.margin,
    this.prefixWidget,
    this.color,
    this.textColor,
    this.enabled = true,
    this.isLoading = false,
    this.width,
  }) : super(key: key);

  final String text;
  final void Function() onPressed;
  final EdgeInsetsGeometry? margin;

  /// Override the color of this button.
  final Color? color;

  /// Override the text color of this button.
  final Color? textColor;

  final Widget? prefixWidget;

  final bool enabled;

  final bool isLoading;

  final double? width;

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      style: const TextStyle(
        color: Colors.indigoAccent
      ),
    );
    return Container(
      height: 46,
      width: width ?? 96,
      child: ProgressButton(
        isDarkMode: false,
        isOutlineButton: true,
        stateWidgets: {
          ButtonState.idle: buildStateWidget(textWidget),
          ButtonState.loading: buildStateWidget(textWidget),
          ButtonState.fail: buildStateWidget(textWidget),
          ButtonState.success: buildStateWidget(textWidget),
        },
        stateColors: () {
          return {
            ButtonState.idle: Colors.indigoAccent,
            ButtonState.loading: Colors.indigoAccent,
            ButtonState.fail: Colors.red,
            ButtonState.success: Colors.green,
          };
        },
        padding: EdgeInsets.all(8),
        radius: isLoading ? 100.0 : 5.0,
        onPressed: !enabled ? null : onPressed,
        state: isLoading ? ButtonState.loading : ButtonState.idle,
        progressIndicatorSize: 30.0,
        progressIndicator: () {
          return const CircularProgressIndicator(
            color: Colors.transparent,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation(Colors.indigoAccent),
          );
        },
      ),
    );
  }

  Widget buildStateWidget(Widget textWidget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        prefixWidget ?? SizedBox(),
        SizedBox(width: prefixWidget == null ? 0 : 8),
        textWidget,
      ],
    );
  }
}


class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.margin,
    this.prefixWidget,
    this.color,
    this.textColor,
    this.enabled = true,
    this.isLoading = false,
    this.width = 96,
  }) : super(key: key);

  final String text;
  final void Function() onPressed;
  final EdgeInsetsGeometry? margin;

  final Widget? prefixWidget;

  /// Override the color of this button.
  final Color? color;

  /// Override the text color of this button.
  final Color? textColor;

  final bool enabled;

  final bool isLoading;

  final double width;

  @override
  Widget build(BuildContext context) {
    const font = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
    final buttonColor = !enabled ? Colors.grey : color ?? Colors.indigoAccent;
    return Container(
      height: 46,
      width: width,
      child: ProgressButton(
        isDarkMode: false,
        isOutlineButton: true,
        stateWidgets: {
          ButtonState.idle: buildStateWidget(Text(
            text,
            maxLines: 2,
            style: font.copyWith(
                color: !enabled
                    ? Colors.grey
                    : textColor ?? font.color),
            textAlign: TextAlign.center,
          )),
          ButtonState.loading: buildStateWidget(Text(
            "Loading",
            maxLines: 2,
            style: font.copyWith(
                color: !enabled
                    ? Colors.grey
                    : textColor ?? font.color),
            textAlign: TextAlign.center,
          )),
          ButtonState.fail: buildStateWidget(Text(
            text,
            maxLines: 2,
            style: font.copyWith(
                color: !enabled
                    ? Colors.grey
                    : textColor ?? font.color),
            textAlign: TextAlign.center,
          )),
          ButtonState.success: buildStateWidget(Text(
            text,
            maxLines: 2,
            style: font.copyWith(
                color: !enabled
                    ? Colors.grey
                    : textColor ?? font.color),
            textAlign: TextAlign.center,
          )),
        },
        stateColors: () {
          return {
            ButtonState.idle: buttonColor,
            ButtonState.loading: buttonColor,
            ButtonState.fail: buttonColor,
            ButtonState.success: buttonColor,
          };
        },
        padding: EdgeInsets.all(8),
        radius: isLoading ? 100.0 : 5.0,
        onPressed: !enabled ? null : onPressed,
        state: isLoading ? ButtonState.loading : ButtonState.idle,
        progressIndicatorSize: 30.0,
        progressIndicator: () {
          return CircularProgressIndicator(
            color: Colors.transparent,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation(Colors.indigoAccent),
          );
        },
      ),
    );
  }

  Widget buildStateWidget(Widget textWidget) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: prefixWidget ?? SizedBox(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: prefixWidget != null ? 18 : 0),
          child: FittedBox(
            fit: BoxFit.contain,
            child: textWidget,
          ),
        ),
      ],
    );
  }
}

class LinkButton extends StatelessWidget {
  const LinkButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.margin,
    this.primary = true,
    this.textColor,
    this.enabled = true,
  }) : super(key: key);

  final String text;
  final void Function() onPressed;
  final EdgeInsetsGeometry? margin;
  final bool primary;

  /// Override the text color of this button.
  final Color? textColor;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final disabledColor = Colors.grey.shade300;

    return Container(
      margin: margin ?? EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(),
      child: Material(
        child: InkWell(
          onTap: !enabled ? null : onPressed,
          child: Ink(
            child: Container(
              padding: EdgeInsets.all(12),
              child: Center(
                child: Text(
                  text,
                ),
              ),
            ),
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }
}
