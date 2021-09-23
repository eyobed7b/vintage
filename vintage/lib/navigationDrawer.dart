import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'authentication/SignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:async';
import 'package:async/async.dart';

import 'global.dart';

class navigationDrawer extends StatefulWidget {
  var user;
  navigationDrawer(this.user);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return navigationDrawerState();
  }
}

class navigationDrawerState extends State<navigationDrawer> {
  File _image;
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: widget.user==null?Center(child: CircularProgressIndicator(),):
        SafeArea(
            child: Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    // margin: EdgeInsets.only(
                    //   top: 6.0,
                    // ),
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 96.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(widget.user['name'],
                                  style: Theme.of(context).textTheme.title),
                              ListTile(
                                contentPadding: EdgeInsets.all(0),
                                title: ButtonTheme(
                                  minWidth: 50.0,
                                  child: FlatButton(
                                      onPressed: () {
                                        signOut(context);
                                      },
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.blue,
                                              width: 1,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      color: Colors.white,
                                      child: Text("Signout")),
                                ),
                                subtitle: Text("Addis Ababa  "),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                    widget.user['image']==null?  CircleAvatar(
                        radius: 43.0,
                        child: Icon(
                          Icons.person,
                          size: 80,
                        ),
                        backgroundColor: Colors.white,
                      ):CircleAvatar(
                          backgroundImage: NetworkImage(
                              IMAGE_IP_POR + "/" + widget.user['image']),
                          maxRadius: 40,
                        ),
                      Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: IconButton(
                            icon: Icon(Icons.photo_camera),
                            onPressed: () => _showPicker(context)),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: new Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          "Core",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListTile(
                        title: Text("Updated profile"),
                        leading: Icon(Icons.system_update),
                      ),
                      ListTile(
                        title: Text("email"),
                        subtitle: Text(widget.user['email']),
                        leading: Icon(Icons.email),
                      ),
                    ],
                  )),
            ],
          ),
        )
      ],
    )));
  }

  Future<void> signOut(context) async {
    FirebaseAuth.instance.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
    uploadImage(_image, PUT_USER + "/" + widget.user['_id']);
  }

  Future<String> uploadImage(filepath, url) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(filepath.openRead()));
    var length = await filepath.length();

    var requestt = new http.MultipartRequest("POST", Uri.parse(url));

    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(filepath.path));
    requestt.files.add(multipartFile);

    var response = await requestt.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
    uploadImage(_image, PUT_USER + widget.user['_id']);
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
