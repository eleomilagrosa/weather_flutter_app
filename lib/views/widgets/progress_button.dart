import 'package:flutter/material.dart';

enum ButtonState { idle, loading, success, fail }

class ProgressButton extends StatefulWidget {
  final Map<ButtonState, Widget> stateWidgets;
  final Map<ButtonState, Color> Function() stateColors;
  final Function? onPressed;
  final Function? onAnimationEnd;
  final ButtonState? state;
  final double minWidth;
  final double maxWidth;
  final double radius;
  final double height;
  final ProgressIndicator Function()? progressIndicator;
  final double progressIndicatorSize;
  final MainAxisAlignment progressIndicatorAlignment;
  final EdgeInsets padding;
  final List<ButtonState> minWidthStates;
  final Duration animationDuration;

  final bool isOutlineButton;

  final bool isDarkMode;

  ProgressButton({
    Key? key,
    required this.stateWidgets,
    required this.stateColors,
    this.state = ButtonState.idle,
    this.onPressed,
    this.onAnimationEnd,
    this.minWidth = 200.0,
    this.maxWidth = 400.0,
    this.radius = 16.0,
    this.height = 53.0,
    this.isOutlineButton = false,
    this.progressIndicatorSize = 35.0,
    this.progressIndicator,
    this.progressIndicatorAlignment = MainAxisAlignment.spaceBetween,
    this.padding = EdgeInsets.zero,
    this.minWidthStates = const <ButtonState>[ButtonState.loading],
    this.animationDuration = const Duration(milliseconds: 500),
    required this.isDarkMode,
  })  : assert(
  stateWidgets.keys.toSet().containsAll(ButtonState.values.toSet()),
  'Must be non-null widgetds provided in map of stateWidgets. Missing keys => ${ButtonState.values.toSet().difference(stateWidgets.keys.toSet())}',
  ),
        assert(
        stateColors()
            .keys
            .toSet()
            .containsAll(ButtonState.values.toSet()),
        'Must be non-null widgetds provided in map of stateWidgets. Missing keys => ${ButtonState.values.toSet().difference(stateColors().keys.toSet())}',
        ),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProgressButtonState();
  }
}

class _ProgressButtonState extends State<ProgressButton>
    with TickerProviderStateMixin {
  AnimationController? colorAnimationController;
  Animation<Color?>? colorAnimation;
  double? width;

  Widget get progressIndicator {
    if (widget.progressIndicator != null) {
      return widget.progressIndicator!();
    } else {
      return CircularProgressIndicator(
          backgroundColor: widget.stateColors()[widget.state!],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
    }
  }

  void startAnimations(ButtonState? oldState, ButtonState? newState) {
    Color? begin = widget.stateColors()[oldState!];
    Color? end = widget.stateColors()[newState!];
    if (widget.minWidthStates.contains(newState)) {
      width = widget.minWidth;
    } else {
      width = widget.maxWidth;
    }
    colorAnimation = ColorTween(begin: begin, end: end).animate(CurvedAnimation(
      parent: colorAnimationController!,
      curve: Interval(
        0,
        1,
        curve: Curves.easeIn,
      ),
    ));
    colorAnimationController!.forward();
  }

  Color? get backgroundColor => colorAnimation == null
      ? widget.stateColors()[widget.state!]
      : colorAnimation!.value ?? widget.stateColors()[widget.state!];

  @override
  void initState() {
    super.initState();

    width = widget.maxWidth;

    colorAnimationController =
        AnimationController(duration: widget.animationDuration, vsync: this);
    colorAnimationController!.addStatusListener((status) {
      if (widget.onAnimationEnd != null) {
        widget.onAnimationEnd!(status, widget.state);
      }
    });
  }

  @override
  void dispose() {
    colorAnimationController!.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProgressButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if ((oldWidget.state != widget.state) || (oldWidget.isDarkMode != widget.isDarkMode)) {
      colorAnimationController?.reset();
      startAnimations(oldWidget.state, widget.state);
    }
  }

  Widget getButtonChild(bool visibility) {
    Widget? buttonChild = widget.stateWidgets[widget.state!];
    if (widget.state == ButtonState.loading) {
      return Row(
        mainAxisAlignment: widget.progressIndicatorAlignment,
        children: <Widget>[
          SizedBox(
            child: progressIndicator,
            width: widget.progressIndicatorSize,
            height: widget.progressIndicatorSize,
          ),
          buttonChild ?? Container(),
          Container()
        ],
      );
    }
    return AnimatedOpacity(
        opacity: visibility ? 1.0 : 0.0,
        duration: Duration(milliseconds: 250),
        child: buttonChild);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: colorAnimationController!,
      builder: (context, child) {
        return AnimatedContainer(
          width: width,
          height: widget.height,
          duration: widget.animationDuration,
          child: MaterialButton(
            padding: widget.padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              side: BorderSide(
                color: widget.isOutlineButton
                    ? backgroundColor ?? Colors.transparent
                    : Colors.transparent,
                width: 1,
              ),
            ),
            color:
            widget.isOutlineButton ? Colors.transparent : backgroundColor,
            disabledColor:
            widget.isOutlineButton ? Colors.transparent : backgroundColor,
            elevation: 0,
            onPressed: widget.onPressed as void Function()?,
            child: getButtonChild(
              colorAnimation == null ? true : colorAnimation!.isCompleted,
            ),
          ),
        );
      },
    );
  }
}
