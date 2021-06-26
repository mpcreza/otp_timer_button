import 'package:flutter/material.dart';
import 'package:otp_timer_button/otp_timer_button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP Timer Button Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'OTP Timer Button Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  OtpTimerButtonController blueController = OtpTimerButtonController();
  OtpTimerButtonController orangeController = OtpTimerButtonController();
  OtpTimerButtonController greenController = OtpTimerButtonController();
  OtpTimerButtonController redController = OtpTimerButtonController();
  OtpTimerButtonController purpleController = OtpTimerButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OtpTimerButton(
              controller: blueController,
              height: 60,
              onPressed: () {},
              text: Text(
                'Resend OTP',
                style: TextStyle(fontSize: 20),
              ),
              duration: 2,
            ),
            OtpTimerButton(
              controller: orangeController,
              height: 60,
              onPressed: () {},
              text: Text(
                'Resend OTP',
                style: TextStyle(fontSize: 20),
              ),
              buttonType: ButtonType.text_button,
              backgroundColor: Colors.orange,
              duration: 2,
            ),
            OtpTimerButton(
              controller: greenController,
              height: 60,
              onPressed: () {},
              text: Text(
                'Resend OTP',
                style: TextStyle(fontSize: 20),
              ),
              buttonType: ButtonType.outlined_button,
              backgroundColor: Colors.green,
              duration: 2,
            ),
            OtpTimerButton(
              controller: redController,
              height: 60,
              onPressed: () {
                redController.loading();
                Future.delayed(Duration(seconds: 2), () {
                  redController.startTimer();
                });
              },
              text: Text(
                'Resend OTP',
                style: TextStyle(fontSize: 20),
              ),
              backgroundColor: Colors.red,
              duration: 2,
            ),
            OtpTimerButton(
              controller: purpleController,
              height: 60,
              onPressed: () {
                purpleController.loading();
                Future.delayed(Duration(seconds: 2), () {
                  purpleController.enableButton();
                });
              },
              text: Text(
                'Resend OTP',
                style: TextStyle(fontSize: 20),
              ),
              backgroundColor: Colors.purple,
              duration: 2,
            ),
          ],
        ),
      ),
    );
  }
}
