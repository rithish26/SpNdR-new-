import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/dash.dart';
import 'package:expenditure/google_sheets.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  final auth = FirebaseAuth.instance;
  late User user;
  String email = "";

  TextEditingController mail = TextEditingController();
  TextEditingController help = TextEditingController();
  late AnimationController controller1;
  late AnimationController controller2;
  late Animation<double> animation1;
  late Animation<double> animation2;
  late Animation<double> animation3;
  late Animation<double> animation4;

  @override
  void initState() {
    controller1 = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 5,
      ),
    );
    animation1 = Tween<double>(begin: .1, end: .15).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller1.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller1.forward();
        }
      });
    animation2 = Tween<double>(begin: .02, end: .04).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    controller2 = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 5,
      ),
    );
    animation3 = Tween<double>(begin: .41, end: .38).animate(CurvedAnimation(
      parent: controller2,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller2.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller2.forward();
        }
      });
    animation4 = Tween<double>(begin: 170, end: 190).animate(
      CurvedAnimation(
        parent: controller2,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    Timer(Duration(milliseconds: 2500), () {
      controller1.forward();
    });

    controller2.forward();
    user = auth.currentUser;
    email = user.email;
    help.text = 'Please Give Editing Acess of the Google Sheet To:';
    mail.text =
        'flutter-gsheets@flutter-gsheets-329714.iam.gserviceaccount.com';

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller1.dispose();
    controller2.dispose();
  }

  var gg = GoogleSheetsApi();
  String name = "";
  String sheetid = "";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('User Profile'),
        brightness: Brightness.light,
      ),
      backgroundColor: Color(0xff192028),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              Positioned(
                top: size.height * (animation2.value + .58),
                left: size.width * .21,
                child: CustomPaint(
                  painter: MyPainter(50),
                ),
              ),
              Positioned(
                top: size.height * .98,
                left: size.width * .1,
                child: CustomPaint(
                  painter: MyPainter(animation4.value - 30),
                ),
              ),
              Positioned(
                top: size.height * .5,
                left: size.width * (animation2.value + .8),
                child: CustomPaint(
                  painter: MyPainter(30),
                ),
              ),
              Positioned(
                top: size.height * animation3.value,
                left: size.width * (animation1.value + .1),
                child: CustomPaint(
                  painter: MyPainter(60),
                ),
              ),
              Positioned(
                top: size.height * .1,
                left: size.width * .8,
                child: CustomPaint(
                  painter: MyPainter(animation4.value),
                ),
              ),
              Column(
                children: [
                  /* Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: (Text("Almost there!!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ))),
                  ),
                ), */
                  /* Center(
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.blue[200],
                    backgroundImage: AssetImage('assets/images/542239-200.png'),
                  ),
                ), */
                  SizedBox(
                    height: 80.0,
                  ),
                  /* Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaY: 100,
                          sigmaX: 100,
                        ),
                        child: TextFormField(
                          maxLines: 2,
                          controller: help,
                          readOnly: true,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(20),
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            hintText: '',
                            hintStyle:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaY: 100,
                          sigmaX: 100,
                        ),
                        child: TextFormField(
                          maxLines: 4,
                          controller: mail,
                          readOnly: true,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () {
                                  Clipboard.setData(
                                          ClipboardData(text: mail.text))
                                      .then(
                                    (value) {
                                      Fluttertoast.showToast(msg: 'Copied!!');
                                    },
                                  );
                                },
                                icon: Icon(Icons.copy),
                                color: Colors.white,
                              ),
                            ),
                            contentPadding: EdgeInsets.all(20),
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            hintText: '',
                            hintStyle:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  SizedBox(
                    height: 50.0,
                  ), */
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaY: 10,
                          sigmaX: 10,
                        ),
                        child: TextField(
                          style: TextStyle(
                              color: Colors.white.withOpacity(1),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(20),
                            suffixIcon: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () {},
                                icon: Icon(Icons.account_box),
                                color: Colors.white,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            hintText: '',
                            hintStyle: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              name = value.trim();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  /* Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaY: 10,
                          sigmaX: 10,
                        ),
                        child: TextField(
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(20),
                            border: OutlineInputBorder(),
                            labelText: 'Google Sheet Link',
                            labelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                            hintText: 'Google Sheet Link',
                            hintStyle:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              sheetid = value.trim();
                            });
                          },
                        ),
                      ),
                    ),
                  ), */
                  SizedBox(
                    height: 12.0,
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue,
                            Colors.purpleAccent,
                            Colors.orange,
                            /*  Color(0xff405DE6),
              Color(0xff5851DB),
              Color(0xff833AB4),
              Color(0xffC13584),
              Color(0xffE1306C),
              Color(0xffFD1D1D),
              Color(0xffF56040),
              Color(0xffF77737),
              Color(0xffFCAF45),
              Color(0xffFFDC80), */
                          ],
                        ),
                        color: Colors.blue[900],
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.black12,
                        ),
                      ),
                      onPressed: () async {
                        if (user.email == "" || name == "") {
                          Alert(
                                  type: AlertType.error,
                                  style: AlertStyle(
                                    backgroundColor: Color(0xff192028),
                                    overlayColor: Colors.transparent,
                                    animationType: AnimationType.fromTop,
                                    descStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    animationDuration:
                                        Duration(milliseconds: 400),
                                    alertBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(color: Colors.white),
                                    ),
                                    titleStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  context: context,
                                  title: "Error",
                                  desc: "Empty Feilds")
                              .show();

                          Fluttertoast.showToast(msg: 'Empty Feilds');
                        } else {
                          final ref = FirebaseFirestore.instance
                              .collection('userdata')
                              .doc(user.uid);
                          ref.set({
                            "email": user.email,
                            "firstname": name,
                            "userid": user.uid,
                            /* "sheetid": sheetid[0] == 'h'
                                ? sheetid.substring(39, 83)
                                : sheetid.substring(31, 75),
                            "sheetlink": sheetid, */
                          });

                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Dash()));
                          /*   Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JobSearch())); */
                        }
                      },
                      child: Text(
                        'DONE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final double radius;

  MyPainter(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
              colors: [Colors.orange, Colors.purple, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)
          .createShader(Rect.fromCircle(
        center: Offset(0, 0),
        radius: radius,
      ));

    canvas.drawCircle(Offset.zero, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
