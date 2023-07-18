import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ta_anywhere/components/auth.dart';
import 'package:email_otp/email_otp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage = '';
  String? selectedGender;
  bool isLogin = true;
  bool isOTPSent = false;
  bool isFormValid = false;
  EmailOTP myauth = EmailOTP();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();
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

      final User user = Auth().currentUser!;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': email,
        'gender': selectedGender,
        'username': _controllerUsername.text,
        'rater': 0,
        'rating': 0,
        'displayPic': true,
      });
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

    if (_controllerPassword.text.length < 6) {
      setState(() {
        errorMessage = "password should be at least 6 characters";
      });
      return;
    }

    if (!isFormValid) {
      setState(() {
        errorMessage = 'Please fill in all fields';
      });
      debugPrint('Error sending OTP: $errorMessage');
      return;
    }

    myauth.setConfig(
      appEmail: "taanywhere@gmail.com",
      appName: "TAanywhere: OTP For Account Registration",
      userEmail: email,
      otpLength: 6,
      otpType: OTPType.digitsOnly,
    );

    if (await myauth.sendOTP() == true) {
      setState(() {
        errorMessage = "OTP Sent Successfully! Please check your email.";
      });
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
    IconData? iconData,
  ) {
    if ((title == 'OTP' || title == 'Username') && isLogin) {
      // Hide OTP field in login mode
      return Container();
    }

    if (title == 'Username') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 40.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.black),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 2.0,
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
            color: Colors.white,
          ),
          child: TextField(
            keyboardType: TextInputType.text,
            obscureText: false,
            controller: controller,
            decoration: InputDecoration(
              labelText: title,
              border: InputBorder.none,
              hintText: title,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
              prefixIcon: Icon(iconData),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 40.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.black),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2.0,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
          color: Colors.white,
        ),
        child: TextField(
          keyboardType: title == 'Email'
              ? TextInputType.emailAddress
              : TextInputType.text,
          obscureText: title == 'Email' || title == 'OTP' ? false : true,
          obscuringCharacter: '*',
          controller: controller,
          enabled: !isOTPSent || (isOTPSent && title == 'OTP'),
          decoration: InputDecoration(
            labelText: title,
            border: InputBorder.none,
            hintText: title == 'Email'
                ? 'Email'
                : title == 'OTP'
                    ? 'OTP'
                    : 'Password',
            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
            prefixIcon: Icon(iconData),
          ),
        ),
      ),
    );
  }

  Widget _errorMessage() {
    return Center(
      child: Text(
        errorMessage == '' ? '' : 'Humm ? $errorMessage',
      ),
    );
  }

  Widget _submitButton() {
    String buttonText = isLogin
        ? 'Login'
        : isOTPSent
            ? 'Verify OTP'
            : 'Send OTP';

    _controllerEmail.addListener(_validateForm);
    _controllerPassword.addListener(_validateForm);
    _controllerUsername.addListener(_validateForm);

    _controllerOTP.addListener(() {
      setState(() {
        if (_controllerOTP.text.isNotEmpty && isOTPSent) {
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

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        onPressed: isLogin
            ? () => signInWithEmailAndPassword()
            : () => isOTPSent
                ? verifyOTP(_controllerEmail.text, _controllerOTP.text)
                : sendOTP(_controllerEmail.text),
        icon: const Icon(
          Icons.arrow_circle_right_outlined,
          color: Colors.white,
        ),
        label: Text(
          buttonText,
          style: const TextStyle(color: Colors.white),
        ),
      ),
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
      child: Text(
        isLogin ? 'Register Instead' : 'Login Instead',
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    if (isLogin) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 40.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.black),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2.0,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
          color: Colors.white,
        ),
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: InputBorder.none,
            labelText: "Gender",
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            prefixIcon: Icon(Icons.face),
          ),
          value: selectedGender,
          onChanged: (value) {
            setState(() {
              selectedGender = value;
            });
          },
          items: const [
            DropdownMenuItem(
              value: 'Male',
              child: Text('Male'),
            ),
            DropdownMenuItem(
              value: 'Female',
              child: Text('Female'),
            ),
            DropdownMenuItem(
              value: 'Prefer not to tell',
              child: Text('Prefer not to tell'),
            ),
          ],
        ),
      ),
    );
  }

  void _validateForm() {
    setState(() {
      if (isLogin) {
        if (_controllerEmail.text.isEmpty || _controllerPassword.text.isEmpty) {
          isFormValid = false;
        } else {
          isFormValid = true;
        }
      } else {
        if (_controllerEmail.text.isEmpty ||
            _controllerPassword.text.isEmpty ||
            _controllerUsername.text.isEmpty ||
            selectedGender == null) {
          isFormValid = false;
        } else {
          isFormValid = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TAanywhere"),
        backgroundColor: const Color.fromARGB(255, 128, 222, 234),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color.fromARGB(255, 128, 222, 234),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Please login to continue.",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                _entryField(
                  'Email',
                  _controllerEmail,
                  Icons.email,
                ),
                const SizedBox(height: 15),
                _entryField(
                  'Password',
                  _controllerPassword,
                  Icons.lock,
                ),
                const SizedBox(height: 15),
                _buildGenderDropdown(),
                const SizedBox(height: 15),
                _entryField(
                  'Username',
                  _controllerUsername,
                  Icons.person,
                ),
                const SizedBox(height: 15),
                _entryField(
                  'OTP',
                  _controllerOTP,
                  Icons.security,
                ),
                _errorMessage(),
                const SizedBox(height: 15),
                Center(
                  child: _submitButton(),
                ),
                const SizedBox(height: 5),
                Center(
                  child: _loginOrRegisterButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
