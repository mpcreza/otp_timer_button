library otp_timer_button;

import 'dart:async';

import 'package:flutter/material.dart';

enum ButtonState { enable_button, loading, timer }

enum ButtonType { elevated_button, text_button, outlined_button }

class OtpTimerButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Text text;
  final ProgressIndicator? loadingIndicator;
  final int duration;
  final OtpTimerButtonController controller;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? loadingIndicatorColor;
  final ButtonType buttonType;
  final double? radius;

  const OtpTimerButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.loadingIndicator,
      required this.duration,
      required this.controller,
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
    widget.controller._addListeners(_startTimer, _loading, _enableButton);
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
            widget.text,
            SizedBox(
              width: 10,
            ),
            Text(
              '$_counter',
              style: widget.text.style,
            ),
          ],
        );
    }
  }

  roundedRectangleBorder() {
    if (widget.radius != null) {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.radius!),
      );
    } else {
      return null;
    }
  }

  _buildButton() {
    switch (widget.buttonType) {
      case ButtonType.elevated_button:
        return ElevatedButton(
          onPressed:
              _state == ButtonState.enable_button ? widget.onPressed : null,
          child: _childBuilder(),
          style: ElevatedButton.styleFrom(
            primary: widget.backgroundColor,
            onPrimary: widget.textColor,
            shape: roundedRectangleBorder(),
          ),
        );
      case ButtonType.text_button:
        return TextButton(
          onPressed:
              _state == ButtonState.enable_button ? widget.onPressed : null,
          child: _childBuilder(),
          style: TextButton.styleFrom(
            primary: widget.backgroundColor,
            shape: roundedRectangleBorder(),
          ),
        );
      case ButtonType.outlined_button:
        return OutlinedButton(
          onPressed:
              _state == ButtonState.enable_button ? widget.onPressed : null,
          child: _childBuilder(),
          style: OutlinedButton.styleFrom(
            primary: widget.backgroundColor,
            shape: roundedRectangleBorder(),
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

  startTimer() {
    _startTimerListener();
  }

  loading() {
    _loadingListener();
  }

  enableButton() {
    _enableButtonListener();
  }
}
