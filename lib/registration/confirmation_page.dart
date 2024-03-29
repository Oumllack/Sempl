import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'elements.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'succesful.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({super.key});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  Timer? _timer;
  int remainingTime = 59;
  bool canResend = false;
  bool isButtonActive = true;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  void _resendOtp() {
    if (canResend) {
      setState(() {
        remainingTime = 59;
        canResend = false;
      });
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Header(),
          SizedBox(
            height: 30,
          ),
          _pinCode(),
          SizedBox(
            width: 330,
            child: Row(
              children: [
                Text(
                  '00:$remainingTime ',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'SourceSansPro',
                    color: Color(0xFF99BFD4),
                  ),
                ),
                canResend
                    ? InkWell(
                        onTap: () {
                          _resendOtp();
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Не получили код? ',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'SourceSansPro',
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Отправь еще раз',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'SourceSansPro',
                                  color: Color(0xFF99BFD4),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : RichText(
                        text: TextSpan(
                          text: 'Не получили код? ',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'SourceSansPro',
                            color: Colors.grey,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Отправь еще раз',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'SourceSansPro',
                                color: Color.fromARGB(255, 197, 213, 221),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CheckBox(
                    onPressed: () {
                      setState(() {
                        isActive = !isActive;
                      });
                    },
                  ),
                  AcceptTermsText(),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: SecondContinueButton(
              isActive: isActive,
            ),
          ),
        ],
      ),
    );
  }
}

class _pinCode extends StatefulWidget {
  const _pinCode({super.key});

  @override
  State<_pinCode> createState() => __pinCodeState();
}

class __pinCodeState extends State<_pinCode> {
  final String requiredNumber = '12345';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: PinCodeTextField(
          backgroundColor: Colors.white,
          appContext: context,
          length: 5,
          keyboardType: TextInputType.number,
          animationType: AnimationType.none,
          cursorColor: Color(0xFF99BFD4),
          textStyle: TextStyle(
            fontSize: 20,
            fontFamily: 'SourceSansPro',
          ),
          onChanged: (value) {
            //value.length>4
            print(value);
          },
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(
              10,
            ),
            fieldHeight: 65,
            fieldWidth: 62,
            inactiveColor: Color(0xFFCECECE),
            activeColor: Color(0xFFCECECE),
            activeBorderWidth: 0.5,
            inactiveBorderWidth: 0.5,
            selectedBorderWidth: 0.5,
            selectedColor: Color(0xFF99BFD4),
          ),
          onCompleted: (value) {
            if (value == requiredNumber) {
              print('valid pin');
            } else {
              print('invalid pin');
            }
          },
        ),
      ),
    );
  }
}
