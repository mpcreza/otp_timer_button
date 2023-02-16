library otp_timer_button;

import 'dart:async';

import 'package:flutter/material.dart';

enum ButtonState { enable_button, loading, timer }

enum ButtonType { elevated_button, text_button, outlined_button }

class OtpTimerButton extends StatefulWidget {
  /// Called when the button is tapped or otherwise activated.
  final VoidCallback? onPressed;

  /// The button text
  final Text text;

  /// the loading indicator
  final ProgressIndicator? loadingIndicator;

  /// Length of the timer in second
  final int duration;

  /// Manual control button state [ButtonState]
  ///
  /// When controller is not null auto start timer is disabled on pressed button
  final OtpTimerButtonController? controller;

  /// Height of the button
  final double? height;

  /// Background color of the button
  final Color? backgroundColor;

  /// Color of the text
  final Color? textColor;

  /// Color of the loading indicator
  final Color? loadingIndicatorColor;

  /// Button type
  /// elevated_button, text_button, outlined_button [ButtonType]
  final ButtonType buttonType;

  /// The radius of the button border
  final double? radius;

  final TextStyle? timerTextStyle;

  const OtpTimerButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.timerTextStyle,
      this.loadingIndicator,
      required this.duration,
      this.controller,
      this.height,
      this.backgroundColor,
      this.textColor,
      this.loadingIndicatorColor,
      this.buttonType = ButtonType.elevated_button,
      this.radius})
      : super(key: key);

  @override
  _OtpTimerButtonState createState() => _OtpTimerButtonState();
}

class _OtpTimerButtonState extends State<OtpTimerButton> {
  Timer? _timer;
  int _counter = 0;
  ButtonState _state = ButtonState.timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    widget.controller?._addListeners(_startTimer, _loading, _enableButton);
  }

  _startTimer() {
    _timer?.cancel();
    _state = ButtonState.timer;
    _counter = widget.duration;

    setState(() {});

    _timer = new Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        if (_counter == 0) {
          _state = ButtonState.enable_button;
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _counter--;
          });
        }
      },
    );
  }

  _loading() {
    _state = ButtonState.loading;
    setState(() {});
  }

  _enableButton() {
    _state = ButtonState.enable_button;
    setState(() {});
  }

  _childBuilder() {
    switch (_state) {
      case ButtonState.enable_button:
        return widget.text;
      case ButtonState.loading:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.text,
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 20,
              height: 20,
              child: widget.loadingIndicator ??
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    color: widget.loadingIndicatorColor,
                  ),
            ),
          ],
        );
      case ButtonState.timer:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_counter',
              style: widget.timerTextStyle,
            ),
            SizedBox(
              width: 10,
            ),
            widget.text,
          ],
        );
    }
  }

  _roundedRectangleBorder() {
    if (widget.radius != null) {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.radius!),
      );
    } else {
      return null;
    }
  }

  _onPressedButton() {
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
    if (widget.controller == null) {
      _startTimer();
    }
  }

  _buildButton() {
    switch (widget.buttonType) {
      case ButtonType.elevated_button:
        return ElevatedButton(
          onPressed:
              _state == ButtonState.enable_button ? _onPressedButton : null,
          child: _childBuilder(),
          style: ElevatedButton.styleFrom(
            primary: widget.backgroundColor,
            onPrimary: widget.textColor,
            shape: _roundedRectangleBorder(),
          ),
        );
      case ButtonType.text_button:
        return TextButton(
          onPressed:
              _state == ButtonState.enable_button ? _onPressedButton : null,
          child: _childBuilder(),
          style: TextButton.styleFrom(
            primary: widget.backgroundColor,
            shape: _roundedRectangleBorder(),
          ),
        );
      case ButtonType.outlined_button:
        return OutlinedButton(
          onPressed:
              _state == ButtonState.enable_button ? _onPressedButton : null,
          child: _childBuilder(),
          style: OutlinedButton.styleFrom(
            primary: widget.backgroundColor,
            shape: _roundedRectangleBorder(),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: _buildButton(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class OtpTimerButtonController {
  late VoidCallback _startTimerListener;
  late VoidCallback _loadingListener;
  late VoidCallback _enableButtonListener;

  _addListeners(startTimerListener, loadingListener, enableButtonListener) {
    this._startTimerListener = startTimerListener;
    this._loadingListener = loadingListener;
    this._enableButtonListener = enableButtonListener;
  }

  /// Notify listener to start the timer
  startTimer() {
    _startTimerListener();
  }

  /// Notify listener to show loading
  loading() {
    _loadingListener();
  }

  /// Notify listener to enable button
  enableButton() {
    _enableButtonListener();
  }
}
