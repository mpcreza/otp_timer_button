# otp_timer_button

This is a Flutter package for easy implementation otp timer button.

![](screenshots/otp_timer-button.gif)

## Installation

    Add the following to your pubspec.yaml file:

    dependencies:
        otp_timer_button: ^1.0.0

## Usage

### Import

    import 'package:otp_timer_button/otp_timer_button.dart';

### Simple Example
    OtpTimerButtonController controller = OtpTimerButtonController();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: OtpTimerButton(
              controller: controller,
              height: 60,
              onPressed: () {},
              text: Text(
                'Resend OTP',
                style: TextStyle(fontSize: 20),
              ),
              duration: 2,
            ),
          ),
        );
    }