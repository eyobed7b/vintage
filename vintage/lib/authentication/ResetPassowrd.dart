import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vintage/authentication/signup.dart';
import 'package:vintage/authentication/widgets/custom_shape.dart';
import 'package:vintage/authentication/widgets/customappbar.dart';
import 'package:vintage/authentication/widgets/responsive_ui.dart';

// import 'package:vintage/widgets/responsive_ui.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ResetPasswordState();
  }
}

class ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> params;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  bool _login = false;
  String err_message;
  bool loading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Scaffold(
      key: scaffoldKey,
      body: Material(
        child: Container(
          height: _height,
          width: _width,
          padding: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Opacity(opacity: 0.88, child: CustomAppBar()),
                clipShape(),
                welcomeTextRow(),
                signInTextRow(),

                form(),
                err_message == null ? Container() : incorrect_message(),

                // SizedBox(height: _height / 12),
                loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : button(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _displaySnackBar(BuildContext context, text) {
    final snackBar = SnackBar(content: Text(text));
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget incorrect_message() {
    return Container(
        child: Padding(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Center(
        child: Text(
          err_message + " ",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
    ));
  }

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
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
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
      child: Row(
        children: <Widget>[
          Text(
            "Reset Password",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _large ? 60 : (_medium ? 35 : 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "insert recovery email account",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: _large ? 20 : (_medium ? 17.5 : 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 15.0),
      child: Form(
        key: _key,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            emailTextFormField(),
            SizedBox(height: _height / 30.0),
          ],
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
        obscureText: false,
        controller: emailController,
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

  Future<void> resetPassword(email) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((value) {
        _displaySnackBar(context, "resting email sent to ${email}");
         setState(() {
             loading = false;
         });
      });
    } catch (err) {
      print(err.message);
      setState(() {
        err_message = err.message;
        loading = false;
      });
    }
  }

  Widget button() {
    String email;
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () async {
        if (_key.currentState.validate()) {
          setState(() {
            loading = true;
            err_message = null;
            email = emailController.text;
          });
          resetPassword(email);
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
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
        child: Text('Reset',
            style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10))),
      ),
    );
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
              print("Routing to Sign up screen");
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.black45,
                  fontSize: _large ? 19 : (_medium ? 17 : 15)),
            ),
          )
        ],
      ),
    );
  }
}
