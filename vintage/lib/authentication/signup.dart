import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vintage/authentication/widgets/custom_shape.dart';
import 'package:vintage/authentication/widgets/customappbar.dart';
import 'package:vintage/authentication/widgets/responsive_ui.dart';

import '../global.dart';
import 'SignIn.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  bool pass_compare = false, userFound = false, loading = false;

  TextEditingController first_name_con = TextEditingController();
  TextEditingController email_con = TextEditingController();
  TextEditingController password_con = TextEditingController();
  TextEditingController comfirmpassword_con = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool visibility_pass = true;
  bool visibility_conf = true;

  var healthCare;
  String healthcareId;
  List<String> listOfHealthCare = [];
  String message;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Opacity(opacity: 0.88, child: CustomAppBar()),
                clipShape(),
                form(),
                loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : acceptTermsTextRow(),
                SizedBox(
                  height: _height / 35,
                ),
                button(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 8
                  : (_medium ? _height / 7 : _height / 6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black45, Colors.black],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 12
                  : (_medium ? _height / 11 : _height / 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black45, Colors.black],
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: _width / 2, top: _height / 100),
          child: Row(
            children: <Widget>[
              Text(
                "Register",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: _large ? 60 : (_medium ? 50 : 40),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            firstNameTextFormField(),
            SizedBox(height: _height / 60.0),
            emailTextFormField(),
            SizedBox(height: _height / 60.0),
            SizedBox(height: _height / 60.0),
            passwordTextFormField(),
            SizedBox(height: _height / 60.0),
            comfirmpasswordTextFormField(),
            SizedBox(height: _height / 60.0),
            pass_compare
                ? password_do_not_match()
                : userFound ? user_found() : Container()
          ],
        ),
      ),
    );
  }

  Widget firstNameTextFormField() {
    double _width;
    double _pixelRatio;
    bool large;
    bool medium;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: large ? 12 : (medium ? 10 : 8),
      child: TextFormField(
        obscureText: false,
        controller: first_name_con,
        keyboardType: TextInputType.text,
        validator: (value) {
          String pattern = r'(^[a-zA-Z ]*$)';
          RegExp regExp = new RegExp(pattern);
          if (value.length == 0) {
            return "Name is Required";
          } else if (!regExp.hasMatch(value)) {
            return "Name must be a-z and A-Z";
          }
          return null;
        },
        cursorColor: Colors.teal[200],
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person, color: Colors.teal[200], size: 20),
          hintText: "Name",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    double _width;
    double _pixelRatio;
    bool large;
    bool medium;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: large ? 12 : (medium ? 10 : 8),
      child: TextFormField(
        controller: email_con,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          String pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regExp = new RegExp(pattern);
          if (value.length == 0) {
            return "Email is Required";
          } else if (!regExp.hasMatch(value)) {
            return "Invalid Email";
          } else {
            return null;
          }
        },
        cursorColor: Colors.teal[200],
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email, color: Colors.teal[200], size: 20),
          hintText: "Email ID",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget passwordTextFormField() {
    double _width;
    double _pixelRatio;

    bool large;
    bool medium;

    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: large ? 12 : (medium ? 10 : 8),
      child: TextFormField(
        obscureText: visibility_pass,
        controller: password_con,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value.length == 0) {
            return "Password can't be empty";
          } else if (value.length < 5) {
            return "Password must be longer than 5 characters";
          }
          return null;
        },
        cursorColor: Colors.teal[200],
        decoration: InputDecoration(
          suffix: IconButton(
              icon: Icon(
                  visibility_pass ? Icons.visibility_off : Icons.visibility,
                  size: 20),
              onPressed: () {
                setState(() {
                  visibility_pass = !visibility_pass;
                });
              }),
          prefixIcon: Icon(Icons.lock, color: Colors.teal[200], size: 20),
          hintText: "Password",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget comfirmpasswordTextFormField() {
    double _width;
    double _pixelRatio;

    bool large;
    bool medium;

    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: large ? 12 : (medium ? 10 : 8),
      child: TextFormField(
        obscureText: visibility_conf,
        controller: comfirmpassword_con,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value.length == 0) {
            return "Password can't be empty";
          } else if (value.length < 5) {
            return "Password must be longer than 5 characters";
          }
          return null;
        },
        cursorColor: Colors.teal[200],
        decoration: InputDecoration(
          suffix: IconButton(
              icon: Icon(
                  visibility_conf ? Icons.visibility_off : Icons.visibility,
                  size: 20),
              onPressed: () {
                setState(() {
                  visibility_conf = !visibility_conf;
                });
              }),
          prefixIcon: Icon(Icons.lock, color: Colors.teal[200], size: 20),
          hintText: "comfirm password",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: Colors.orange[200],
              value: checkBoxValue,
              onChanged: (bool newValue) {
                setState(() {
                  checkBoxValue = newValue;
                });
              }),
          Text(
            "I accept all terms and conditions",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Future<void> localServer(email, uid, name) async {
    await http
        .post(URL_SIGNUP,
            headers: {"Content-Type": "application/json"},
            body: json.encode({"name": name, "email": email, "uid": uid}))
        .then((value) => Navigator.of(context).pushReplacementNamed("Home"));
  }

  Future<void> register(email, password, name) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print(value.user.email);

        localServer(email, value.user.uid, name);
      });
    } catch (er) {
      setState(() {
        loading = false;
        userFound = true;
        message = er.message;
      });
    }
    ;
  }

  Widget password_do_not_match() {
    return Container(
      child: Center(
        child: Text(
          "passords do not much",
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget user_found() {
    return Container(
        child: Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 10),
      child: Center(
        child: Text(
          message + " ",
          style: TextStyle(color: Colors.red),
        ),
      ),
    ));
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () async {
        setState(() {
          userFound = false;
          pass_compare = false;
        });

        if (comfirmpassword_con.text == password_con.text) {
          if (_key.currentState.validate()) {
            setState(() {
              pass_compare = false;
              loading = true;
            });
            //   localServer(email_con.text, password_con.text, first_name_con);
            register(email_con.text, password_con.text, first_name_con.text);
          }
        } else {
          setState(() {
            loading = false;
            pass_compare = true;
          });
          print(pass_compare);
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
//        height: _height / 20,
        width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[
              Colors.teal[100],
              Colors.teal[400],
              Colors.teal[800],
              Colors.black
            ],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'SIGN UP',
          style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
        ),
      ),
    );
  }

  Widget infoTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Or create using social media",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInPage()));
              print("Routing to Sign up screen");
            },
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.orange[200],
                  fontSize: 19),
            ),
          )
        ],
      ),
    );
  }
}
