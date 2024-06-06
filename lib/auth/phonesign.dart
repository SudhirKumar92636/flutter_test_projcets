import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test_projcets/auth/verfiyotp.dart';
import 'package:flutter_test_projcets/views/bottomnav/bottomnav.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneScreen extends StatefulWidget {
  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,

        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: ClipRect(
                  child: Image.asset("assets/images/phoneicon.png"),
                ),
              ),
              const Text(
                "Verifications",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text("Please enter your phone number",style: TextStyle(fontSize: 15),),
              const Text("to receive a verification code",style: TextStyle(fontSize: 15)),
              const SizedBox(height: 16),

              IntlPhoneField(
                controller: _phoneController,
                decoration: const InputDecoration(
                    labelText: 'Enter Phone Number',
                    border: OutlineInputBorder(
                        borderSide: BorderSide()
                    )
                ),

              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      await phoneAuth(_phoneController.text);

                    }
                  },
                  child: _isLoading ? const CircularProgressIndicator() : const Text("GENERATE OTP",style: TextStyle(fontSize: 20,color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> phoneAuth(String number) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91$number",
        verificationCompleted: (credential) {
          _signInWithCredential(credential);
        },
        verificationFailed: (exception) {
          setState(() {
            _isLoading = false;
          });
          Fluttertoast.showToast(
              msg: "Verification Failed: ${exception.message}");
        },
        codeSent: (verificationId, forceResendingToken) {
          setState(() {
            _isLoading = false;
            _verificationId = verificationId;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyOTP(
                verificationId: verificationId,
                phoneNumber: _phoneController.text,

              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {
          // No need to handle navigation here
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }


  void _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const BottomNavigationsPages()),
      );
      Fluttertoast.showToast(msg: "Login successful");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }
}
