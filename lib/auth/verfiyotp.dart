import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';

import '../views/addusersdetails/addusers.dart';
import '../views/addusersdetails/addusersrealtime.dart';
import '../views/bottomnav/bottomnav.dart';


class VerifyOTP extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const VerifyOTP({Key? key, required this.verificationId, required this.phoneNumber}) : super(key: key);
  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}
class _VerifyOTPState extends State<VerifyOTP> {
  TextEditingController  pinController = TextEditingController();
  late Timer _timer;
  int _resendTimer = 60;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    pinController = TextEditingController();
    focusNode = FocusNode(); // Initialize focusNode
    startResendTimer();
  }

  @override
  void dispose() {
    pinController.dispose();
    _timer.cancel();
    focusNode.dispose();
    super.dispose();
  }

  void startResendTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void resendOTP() {
    if (widget.phoneNumber.isNotEmpty) {
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phoneNumber}',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (credential) {},
        verificationFailed: (exception) {
          Fluttertoast.showToast(msg: "Error: ${exception.message}");
        },
        codeSent: (verificationId, forceResendingToken) {
          setState(() {
            _resendTimer = 60;
          });
          Fluttertoast.showToast(msg: "OTP Resent");
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } else {
      Fluttertoast.showToast(msg: "Phone number is empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/verifications.png",
                      width: 100,
                      height: 150,
                    ),
                    Text("Enter the Otp send to +91${widget.phoneNumber}",style: const TextStyle(fontWeight: FontWeight.bold,),),
                    const SizedBox(
                      height: 20,
                    ),
                    Pinput(
                      controller: pinController,
                      focusNode: focusNode,
                      androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
                      listenForMultipleSmsOnAndroid: true,
                      separatorBuilder: (index) => const SizedBox(width: 6),
                      length: 6,
                      validator: (value) {

                        return value == pinController ? null : null;
                      },
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (pin) {
                        debugPrint('onCompleted: $pin');
                      },
                      onChanged: (value) {
                        debugPrint('onChanged: $value');
                      },
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 9),
                            width: 22,
                            height: 1,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            await signInWithOTP(pinController.text);
                          } catch (e) {
                            Fluttertoast.showToast(msg: "Enter Valid OTP");
                          }
                        },
                        child: const Text("VERIFY OTP && CONTINUE"),
                      ),),
                    const SizedBox(height: 10),
                    _resendTimer > 0
                        ? Text(
                      'Resend OTP in $_resendTimer seconds',
                      style: const TextStyle(color: Colors.grey),
                    )
                        : Row(
                      children: [
                        const Text("Don't receive the Otp?  "),
                        TextButton(onPressed: (){
                          resendOTP();
                        }, child:const Text('Resend OTP',style: TextStyle(fontWeight: FontWeight.bold) ),)
                      ],
                    ),
                  ],
                ),
              ),
            ]

        ));
  }

  Future<void> signInWithOTP(String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Registrations()),
      );
      Fluttertoast.showToast(msg: "Login successful");

    } catch (e) {
      Fluttertoast.showToast(msg: "Enter Valid OTP");
    }
  }
}
