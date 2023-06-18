import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ta_anywhere/components/auth.dart';
import 'package:email_otp/email_otp.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage = '';
  bool isLogin = true;
  bool isOTPSent = false;
  EmailOTP myauth = EmailOTP();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerOTP = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    final String email = _controllerEmail.text.trim();

    try {
      await Auth().createUserWithEmailAndPassword(
        email: email,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> sendOTP(String email) async {
    if (!email.endsWith("@u.nus.edu")) {
      setState(() {
        errorMessage = 'email must end with "@u.nus.edu"';
      });
      debugPrint('Error sending OTP: $errorMessage');
      return;
    }

    myauth.setConfig(
      appEmail: "taanywhere@gmail.com",
      appName: "Email OTP",
      userEmail: email,
      otpLength: 6,
      otpType: OTPType.digitsOnly
    );

    if (await myauth.sendOTP() == true) {
      debugPrint('OTP Sent');
      isOTPSent = true;
    } else {
      setState(() {
        errorMessage = "Oops, OTP send failed";
      });
      debugPrint('Error verifying OTP: $errorMessage');
    }
  }

  Future<void> verifyOTP(String email, String otp) async {

    if (await myauth.verifyOTP(otp: otp) == true) {
      createUserWithEmailAndPassword();
    } else {
      setState(() {
        errorMessage = "Invalid OTP";
      });
      debugPrint('Error verifying OTP: $errorMessage');
    }
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      keyboardType: title == 'Email'
          ? TextInputType.emailAddress
          : TextInputType.text,
      obscureText: title == 'Email' || title == 'OTP' ? false : true,
      obscuringCharacter: '*',
      controller: controller,
      enabled: !isOTPSent || (isOTPSent && title == 'OTP'),
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(),
        hintText: title == 'Email'
            ? 'Email'
            : title == 'OTP'
                ? 'OTP'
                : 'Password',
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitButton() {
    String buttonText = isLogin
        ? 'Login'
        : isOTPSent
            ? 'Verify OTP'
            : 'Send OTP';

    _controllerOTP.addListener(() {
      setState(() {
        if (_controllerOTP.text.isNotEmpty && !isOTPSent) {
          buttonText = 'Submit OTP';
        } else {
          buttonText = isLogin
              ? 'Login'
              : isOTPSent
                  ? 'Verify OTP'
                  : 'Send OTP';
        }
      });
    });

    return ElevatedButton.icon(
      onPressed: isLogin
          ? () => signInWithEmailAndPassword()
          : () => isOTPSent
              ? verifyOTP(_controllerEmail.text, _controllerOTP.text)
              : sendOTP(_controllerEmail.text),
      icon: const Icon(Icons.arrow_circle_right_outlined),
      label: Text(buttonText),
    );
  }



  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
          isOTPSent = false;
        });
      },
      child: Text(isLogin ? 'Register Instead' : 'Login Instead'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TAanywhere"),
        backgroundColor: const Color.fromARGB(255, 128, 222, 234),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Please login to continue.",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 100, height: 40),
            _entryField('Email', _controllerEmail),
            const SizedBox(width: 100, height: 15),
            _entryField('Password', _controllerPassword),
            const SizedBox(width: 100, height: 15),
            _entryField('OTP', _controllerOTP),
            _errorMessage(),
            const SizedBox(width: 100, height: 15),
            _submitButton(),
            _loginOrRegisterButton(),
          ],
        ),
      ),
    );
  }
}
