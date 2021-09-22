import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'authentication/SignIn.dart';
import 'authentication/SplashScreen.dart';
 import 'package:firebase_core/firebase_core.dart';

import 'home.dart';
 
 

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
     
      return runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "E-Health Center",
      theme: ThemeData(
        primaryColor: Colors.teal[700],
        // primarySwatch: customPrimary,
        primaryColorLight:  Colors.teal[400],
        
        primaryColorDark:  Colors.teal[900],
        
        ),

      routes: <String, WidgetBuilder>{
        "SPLASH_SCREEN": (BuildContext context) =>  SplashScreen(),
        "SIGN_IN": (BuildContext context) =>  SignInPage(),
        // "SIGN_UP": (BuildContext context) =>  SignUpScreen(),
        "Home":(BuildContext context)=>Home(),

      },
      initialRoute: "SPLASH_SCREEN",
    );
  }
}



