import 'dart:io';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hallo/models/uid.dart';
import 'package:hallo/models/uid.dart';
import 'package:hallo/models/user.dart';
import 'package:hallo/screens/nav_menu/nav_menu.dart';
import 'package:hallo/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hallo/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {


  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      String fileName = basename(_image.path);
      print('Image Path $_image');


    });
  }



  Future uploadPic(BuildContext context) async{
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profiles/$current_user_uid');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() async{
        uploadedFileURL = fileURL;
        print("File url : $uploadedFileURL");

        await DatabaseService(uid: current_user_uid).updateProfile(uploadedFileURL);

      });
    });

  }





  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String name;
    String status;
    String phone;
    String email;
    String imageUrl;

    final user =Provider.of<User>(context);

    void _showEditProfile(String n,String s, String p,String e) {

      showModalBottomSheet(

          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: Column(
                children: <Widget>[
                  Center(
                      child: Text("Edit Profile")),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                        width: 2.0,
                      ),
                    ),
                    child: TextFormField(
                      initialValue: n,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.all(12.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.pink, width: 2.0),
                          ),
                          hintText: "Enter name",
                          hintStyle: TextStyle(color: Colors.grey[400])),

                      onChanged: (val) {
                        setState(() {
                          n = val;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                        width: 2.0,
                      ),
                    ),
                    child: TextFormField(initialValue: s,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.all(12.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.white, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.pink, width: 2.0),
                          ),
                          hintText: "Enter Status",
                          hintStyle: TextStyle(color: Colors.grey[400])),

                      onChanged: (val) {
                        setState(() {
                          s = val;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                        width: 2.0,
                      ),
                    ),
                    child: TextFormField(
                      initialValue: p,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.all(12.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.white, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.pink, width: 2.0),
                          ),
                          hintText: "Enter Phone no.",
                          hintStyle: TextStyle(color: Colors.grey[400])),

                      onChanged: (val) {
                        setState(() {
                          p = val;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 12, horizontal: 40),

                    color: Colors.lightGreen,
                    child: Text(
                      "Update",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,),
                    ),
                    onPressed: () async {

                      await DatabaseService(uid: user.uid).updateUserData(n, s, p, e);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          });
    }



    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: current_user_uid).userData ,
        builder: (context, snapshot)  {

          if (!(snapshot.hasData)) {


            return AlertDialog(
              title: Text('Failed to Retreive Data'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Make sure you are connected to the internet'),
                    Text('Else firebase is just down sorry :('),
                    Text('Comeback later'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'okay',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/chats');
                  },
                ),
              ],
            );
          } else {

            UserData userData = snapshot.data;
            print("profile pic : ${userData.imageUrl}");
            return Scaffold(
              drawer: Nav_menu(),
              backgroundColor: Colors.grey[900],
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () {
                  _showEditProfile(userData.name,userData.status,userData.phone,userData.email);
                },
                backgroundColor: Colors.grey[800],
              ),
              appBar: AppBar(
                title: Text("Profile"),
                centerTitle: true,
                backgroundColor: Colors.grey[850],
                elevation: 0.0,
              ),
              body: Padding(
                padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                      children:<Widget>[
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/'),
                          radius: 60.0,
                          child: ClipOval(
                            child: new SizedBox(
                              width: 180,
                              height: 180,
                              child: userData.imageUrl!=null?Image.network(
                                userData.imageUrl,
                                fit: BoxFit.cover ,
                              ):Container(
                                color: Colors.amber,
                              )
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 60.0),
                          child: IconButton(
                            icon: Icon(
                              FontAwesomeIcons.cameraRetro,
                              color: Colors.amber,
                              size: 30.0,
                            ),
                            onPressed: () async {
                              await getImage();
                              uploadPic(context);
                            },
                          ),
                        ),

    ],
                    ),
                    Divider(
                      height: 60,
                      color: Colors.grey[500],
                    ),
                    Text(
                      "NAME",
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      userData.name,
                      style: TextStyle(
                          color: Colors.amberAccent[200],
                          letterSpacing: 2.0,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "STATUS",
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      userData.status,
                      style: TextStyle(
                          color: Colors.amberAccent[200],
                          letterSpacing: 2.0,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.email,
                          color: Colors.grey[400],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          userData.email,
                          style: TextStyle(
                            color: Colors.grey[400],
                            letterSpacing: 1.0,
                            fontSize: 18.0,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.phone,
                          color: Colors.grey[400],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '+91 ${userData.phone}',
                          style: TextStyle(
                            color: Colors.grey[400],
                            letterSpacing: 1.0,
                            fontSize: 18.0,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        });
  }
}