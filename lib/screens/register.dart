// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../service/auth.dart';
import '../service/dataBase.dart';
import 'otp.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

final AuthService authService = Get.put(AuthService());
final _auth = FirebaseAuth.instance;

class _RegisterState extends State<Register> {
  late DateTime currentBackPressTime;
  String verificationIdFinal = "";
  String phoneNumber = '';
  late String phoneIsoCode;
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'US';
  PhoneNumber number = PhoneNumber(isoCode: 'US');
  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      // _phone = internationalizedPhoneNumber;
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  final List<String> dropdownItems = [
    'Football',
    'Basketball',
    'Ice Hockey',
    'Motorsports',
    'Bandy',
    'Rugby'
  ];
  final dropdownValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dropdownValueController.text = dropdownItems.first;
  }

  TextEditingController interestValueController = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _date = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
    _username.dispose();
    _confirmPassword.dispose();
    _date.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
       floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[200]!.withOpacity(0.5),
          child: Icon(Icons.arrow_back,),
          onPressed: () async {
            Get.back();
          },
        ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage('assets/sportify.jpeg'), fit: BoxFit.cover),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0.0,
              left: 0.0,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.1, 0.3, 0.5, 0.7, 0.9],
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.55),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(1.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.teal,
                  elevation: 0.0,
                  title: const Text('Signup'),
                ),
                body: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    const SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200]!.withOpacity(0.5),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: TextFormField(
                                validator: (val) =>
                                    val!.isEmpty ? 'Enter Username' : null,
                                cursorColor: Colors.teal,
                                controller: _username,
                                style: const TextStyle(
                                  color: Colors.teal,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 20.0),
                                  hintText: 'Name',
                                  hintStyle: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200]!.withOpacity(0.5),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: TextFormField(
                                validator: (val) =>
                                    val!.isEmpty ? 'Enter an email' : null,
                                cursorColor: Colors.teal,
                                controller: _email,
                                style: const TextStyle(
                                  color: Colors.teal,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 20.0),
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(height: 20.0),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              padding: const EdgeInsets.only(left: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200]!.withOpacity(0.5),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: InternationalPhoneNumberInput(
                                onInputChanged: (value) {
                                  phoneNumber = value.phoneNumber!;
                                  print("my phone $phoneNumber");
                                },
                                textStyle: const TextStyle(
                                  color: Colors.teal,
                                  // color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                autoValidateMode: AutovalidateMode.disabled,
                                selectorTextStyle: const TextStyle(
                                  color: Colors.teal,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                initialValue: number,
                                textFieldController: controller,
                                inputBorder: InputBorder.none,
                                inputDecoration: const InputDecoration(
                                  // contentPadding: EdgeInsets.only(left: 10.0),
                                  hintText: 'Phone Number',
                                  hintStyle: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                ),
                                // selectorType: PhoneInputSelectorType.DIALOG,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200]!.withOpacity(0.5),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: TextFormField(
                                validator: (val) => val!.length < 6
                                    ? 'Enter a valid password 6+ chars long'
                                    : null,
                                cursorColor: Colors.teal,
                                controller: _password,
                                style: const TextStyle(
                                  color: Colors.teal,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                obscureText: true,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 20.0),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200]!.withOpacity(0.5),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: TextFormField(
                                validator: (val) {
                                  if (val == _password.toString()) {
                                    return null;
                                  } else {
                                    return 'password do not match';
                                  }
                                },
                                cursorColor: Colors.teal,
                                controller: _confirmPassword,
                                style: const TextStyle(
                                  color: Colors.teal,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                obscureText: true,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 20.0),
                                  hintText: 'Confirm Password',
                                  hintStyle: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200]!.withOpacity(0.5),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: DateTimePicker(
                                controller: _date,
                                initialValue: null,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 20.0),
                                  hintText: 'Date of Birth',
                                  hintStyle: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                ),
                                // dateLabelText: 'Date',
                                onChanged: (val) => print(val),
                                validator: (val) {
                                  print(val);
                                  return null;
                                },
                                onSaved: (val) => print(val),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200]!.withOpacity(0.5),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20.0)),
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: dropdownValueController.text,
                                  items: dropdownItems.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                            color: Colors.teal,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? val) {
                                    if (val != null) {
                                      setState(() {
                                        dropdownValueController.value =
                                            dropdownValueController.value
                                                .copyWith(text: val);
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Select Interest',
                                    iconColor: Colors.teal,
                                    fillColor: Colors.teal,
                                    prefixIconColor: Colors.teal,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                )),
                          ),
                          const SizedBox(height: 40.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30.0),
                              onTap: () async {
                                // if(_formKey.currentState.validate()){
                                String user = await authService.createAccount(
                                    email: _email.text.trim(),
                                    password: _password.text.trim());
    
                                await DatabaseService(uid: _auth.currentUser!.uid)
                                    .updateUserData(
                                        _username.text.trim(),
                                        _email.text.trim(),
                                        controller.text.trim(),
                                        _password.text.trim(),
                                        _date.text,
                                        dropdownValueController.text);
    
                                await authService.verifyPhoneNumber(
                                    phoneNumber, context, setData);
    
                                if (user.isNotEmpty) {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: OTPScreen()));
                                }
    
                                // }
                              },
                              child: Container(
                                height: 50.0,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.bottomRight,
                                    stops: const [0.1, 0.5, 0.9],
                                    colors: [
                                      Colors.teal[300]!.withOpacity(0.8),
                                      Colors.teal[500]!.withOpacity(0.8),
                                      Colors.teal[800]!.withOpacity(0.8),
                                    ],
                                  ),
                                ),
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setData(String verificationId) {
    setState(() {
      verificationIdFinal = verificationId;
    });
    // startTimer();
  }
}
