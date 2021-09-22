import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'global.dart';

import 'navigationDrawer.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<Home> {
  var user;
  @override
  void initState() {
    getUser();
    // TODO: implement initState
    super.initState();
  }

  Future<void> getUser() async {
    await http
        .get(GET_USER + "/" + FirebaseAuth.instance.currentUser.uid)
        .then((value) {
      setState(() {
        user = json.decode(value.body);
      });
      print(json.decode(value.body));
      // user = new  User.get(json.decode(value.body));
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: navigationDrawer(user),
    );
  }
}
