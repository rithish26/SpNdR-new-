import 'dart:async';
import 'dart:ui';

import 'package:blurry/blurry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/dash.dart';
import 'package:expenditure/google_sheets.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class Editp extends StatefulWidget {
  @override
  _EditpState createState() => _EditpState();
}

class _EditpState extends State<Editp> with TickerProviderStateMixin {
  TextEditingController _sheetid = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController help = TextEditingController();
  TextEditingController mail = TextEditingController();
  late AnimationController controller1;
  late AnimationController controller2;
  late Animation<double> animation1;
  late Animation<double> animation2;
  late Animation<double> animation3;
  late Animation<double> animation4;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
    help.text = 'Please Give Editing Acess of the Google Sheet To:';
    mail.text =
        'flutter-gsheets@flutter-gsheets-329714.iam.gserviceaccount.com';
    FirebaseFirestore.instance
        .collection('userdata')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        _name.text = value['firstname'];
        _sheetid.text = value['sheetlink'];
      });
    });
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  var gg = GoogleSheetsApi();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      /*  floatingActionButton: FloatingActionButton.extended(
        focusColor: Colors.blue,
        hoverColor: Colors.orange,
        splashColor: Colors.purple,
        foregroundColor: Colors.black,
        label: Text('Access Google Sheet'),
        onPressed: () {
          _launchUrl(_sheetid.text);
          /* Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Addtransaction(
                gg: gg,
              ),
            ), 
          );*/
        },
        icon: Icon(
          Icons.article_outlined,
          color: Colors.black,
          size: 30,
        ),
        backgroundColor: Colors.grey[200],
      ), */
      appBar: AppBar(
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          ),
        ),
        backgroundColor: Colors.transparent,
        title: Text('User Profile'),
      ),
      backgroundColor: Color(0xff192028),
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
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, top: 00.0, right: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /* Center(
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.blue[200],
                        backgroundImage: AssetImage('assets/images/542239-200.png'),
                      ),
                    ),
                     */

                      SizedBox(
                        height: 10.0,
                      ),
                      /* ClipRRect(
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
                              hintStyle: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
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
                      SizedBox(
                        height: 4,
                      ),
                      ClipRRect(
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
                              hintStyle: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
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
                      SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        height: 60.0,
                      ), */
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaY: 10,
                            sigmaX: 10,
                          ),
                          child: TextField(
                            controller: _name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
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
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: 'Enter your Username',
                              hintStyle: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
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
                      SizedBox(
                        height: 10.0,
                      ),
                      /* ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaY: 10,
                            sigmaX: 10,
                          ),
                          child: TextField(
                            controller: _sheetid,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
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
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: 'Enter your Google SheetLink',
                              hintStyle: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
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
                            if (FirebaseAuth.instance.currentUser.email == "" ||
                                _name.text == "" ||
                                _sheetid.text == "") {
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
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          side: BorderSide(color: Colors.white),
                                        ),
                                        titleStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      context: context,
                                      title: "Error",
                                      desc: "Empty Fierlds")
                                  .show();
                            } else {
                              String eg = _sheetid.text;

                              final ref = FirebaseFirestore.instance
                                  .collection('userdata')
                                  .doc(FirebaseAuth.instance.currentUser.uid);
                              ref.update({
                                "email":
                                    FirebaseAuth.instance.currentUser.email,
                                "firstname": _name.text,
                                "userid": FirebaseAuth.instance.currentUser.uid,
                                /*  "sheetid": _sheetid.text[0] == 'h'
                                    ? _sheetid.text.substring(39, 83)
                                    : _sheetid.text.substring(31, 75),
                                "sheetlink": _sheetid.text, */
                              });

                              Future.delayed(Duration(milliseconds: 1000), () {
                                // Do something
                              });
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => Dash()),
                                (Route<dynamic> route) => false,
                              );
                              /*   Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => JobSearch())); */
                            }
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _launchUrl(String urlString) async {
    try {
      await launch(
        urlString,
      );
    } catch (e) {
      print(e);
    }
    /* if (await canLaunch(urlString)) {
      await launch(
        urlString,
        forceWebView: true,
      );
    } else {
      print(urlString);
      print("Can\'t Launch Url");
    }*/
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
