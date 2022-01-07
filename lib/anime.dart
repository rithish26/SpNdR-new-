import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:expenditure/dash.dart';
import 'package:expenditure/profile.dart';
import 'package:expenditure/reset.dart';
import 'package:expenditure/signup.dart';
import 'package:expenditure/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AnimeHomePage extends StatefulWidget {
  @override
  _AnimeHomePageState createState() => _AnimeHomePageState();
}

class _AnimeHomePageState extends State<AnimeHomePage>
    with TickerProviderStateMixin {
  String _email = "";
  String _password = "";
  final auth = FirebaseAuth.instance;
  final formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late AnimationController controller1;
  late AnimationController controller2;
  late Animation<double> animation1;
  late Animation<double> animation2;
  late Animation<double> animation3;
  late Animation<double> animation4;
  bool check() {
    bool f = false;
    User user = FirebaseAuth.instance.currentUser;
    var collection = FirebaseFirestore.instance.collection('userdata');
    collection.doc(user.uid).get().then((value) {
      if (value.exists)
        f = true;
      else
        f = false;
    });
    return f;
  }

  @override
  void initState() {
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

    User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var collection = FirebaseFirestore.instance.collection('userdata');
      collection.doc(user.uid).get().then((value) {
        if (value.exists) {
          if (user.emailVerified) {
            /* //if there isn't any user currentUser function returns a null so we should check this case.
      Navigator.pushReplacement(
          // we are making YourHomePage widget the root if there is a user.
          context,
          MaterialPageRoute(builder: (context) => JobSearch())); */
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => Dash()));
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  bool isPasswordVisible = true;
  ontap() {}
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff192028),
      body: Form(
        key: formkey,
        child: SingleChildScrollView(
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
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 140,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: (Text("SpNdR",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                    ))),
                              ),
                            ),
                            SizedBox(height: 50),
                            SizedBox(
                              height: 30,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaY: 10,
                                  sigmaX: 10,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(1),
                                        fontSize: 20),
                                    cursorColor: Colors.white,
                                    obscureText: false,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: IconButton(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onPressed: () {},
                                          icon: Icon(Icons.email),
                                          color: Colors.white,
                                        ),
                                      ),
                                      border: OutlineInputBorder(),
                                      hintMaxLines: 1,
                                      hintText: 'Email...',
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
                                      _email = value.trim();
                                    },
                                    validator: (_email) => _email != null &&
                                            !EmailValidator.validate(_email)
                                        ? 'Enter a valid Email'
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaY: 10,
                                  sigmaX: 10,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(1),
                                        fontSize: 20),
                                    cursorColor: Colors.white,
                                    obscureText: isPasswordVisible,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(
                                          Icons.lock_outline,
                                          color: Colors.white.withOpacity(1),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        hintMaxLines: 1,
                                        hintText: 'Password...',
                                        hintStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white.withOpacity(1),
                                            fontWeight: FontWeight.bold),
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: IconButton(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onPressed: () {
                                              if (isPasswordVisible) {
                                                setState(() {
                                                  isPasswordVisible = false;
                                                });
                                              } else {
                                                setState(() {
                                                  isPasswordVisible = true;
                                                });
                                              }
                                            },
                                            icon: Icon(
                                              isPasswordVisible
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )),
                                    onChanged: (value) {
                                      _password = value.trim();
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isloading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ))
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaY: 15, sigmaX: 15),
                                          child: InkWell(
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            onTap: () async {
                                              HapticFeedback.lightImpact();
                                              print(_email);
                                              print(_password);
                                              try {
                                                {
                                                  final form =
                                                      formkey.currentState!;
                                                  if (form.validate()) {
                                                    setState(() {
                                                      isloading = true;
                                                    });
                                                    print(_email);
                                                    print(_password);
                                                    await auth
                                                        .signInWithEmailAndPassword(
                                                            email: _email,
                                                            password:
                                                                _password);
                                                    final usere =
                                                        auth.currentUser;
                                                    var collection =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'userdata');
                                                    var docSnapshot =
                                                        await collection
                                                            .doc(usere.uid)
                                                            .get();

                                                    if (usere != null &&
                                                        docSnapshot.exists) {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  Dash()));
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Welcome Back!!');

                                                      setState(() {
                                                        isloading = false;
                                                      });
                                                    } else if (!usere
                                                            .emailVerified &&
                                                        usere != null) {
                                                      Fluttertoast.showToast(
                                                          msg: 'Not verified');
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                VerifyScreen()),
                                                        (Route<dynamic>
                                                                route) =>
                                                            false,
                                                      );
                                                    } else if (!docSnapshot
                                                            .exists &&
                                                        usere != null) {
                                                      Fluttertoast.showToast(
                                                          msg: 'Data Missing');
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Profile()),
                                                        (Route<dynamic>
                                                                route) =>
                                                            false,
                                                      );

                                                      setState(() {
                                                        isloading = false;
                                                      });
                                                    }
                                                  }
                                                }
                                              } catch (e) {
                                                print(e);
                                                Alert(
                                                        type: AlertType.error,
                                                        style: AlertStyle(
                                                          backgroundColor:
                                                              Color(0xff192028),
                                                          overlayColor: Colors
                                                              .transparent,
                                                          animationType:
                                                              AnimationType
                                                                  .fromTop,
                                                          descStyle: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                          animationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      400),
                                                          alertBorder:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          titleStyle: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        context: context,
                                                        title: "Error",
                                                        desc:
                                                            "wrong password or mail id")
                                                    .show();
                                                /*  showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      _buildPopupDialog(context,
                                                          "wrong password or mail id"),
                                                ); */
                                                setState(() {
                                                  isloading = false;
                                                });
                                              }
                                            },
                                            child: Container(
                                              height: size.width / 8,
                                              width: size.width / 2.58,
                                              alignment: Alignment.center,
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
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Text(
                                                'LOGIN',
                                                style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(1),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                SizedBox(width: size.width / 20),
                                component2(
                                  'Forgotten password!',
                                  2.58,
                                  () {
                                    HapticFeedback.lightImpact();
                                    Fluttertoast.showToast(
                                        msg: 'Forgotten password');
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ResetScreen()));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            component2(
                              'Create a new Account',
                              2,
                              () {
                                HapticFeedback.lightImpact();
                                Fluttertoast.showToast(
                                    msg: 'Create a new account');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupPage()),
                                );
                              },
                            ),
                            SizedBox(height: size.height * .05),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget component3(
      IconData icon, String hintText, bool isPassword, bool isEmail) {
    Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: 10,
          sigmaX: 10,
        ),
        child: Container(
          height: size.width / 8,
          width: size.width / 1.2,
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: size.width / 30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.05),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextFormField(
            style: TextStyle(color: Colors.white.withOpacity(1), fontSize: 20),
            cursorColor: Colors.white,
            obscureText: false,
            keyboardType:
                isEmail ? TextInputType.emailAddress : TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: Colors.white.withOpacity(1),
              ),
              border: InputBorder.none,
              hintMaxLines: 1,
              hintText: hintText,
              hintStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white.withOpacity(1),
                  fontWeight: FontWeight.bold),
            ),
            onChanged: (value) {
              _email = value.trim();
            },
            /* validator: isPassword
                ? null
                : (email) => email != null && !EmailValidator.validate(email)
                    ? 'Enter a valid Email'
                    : null, */
          ),
        ),
      ),
    );
  }

  Widget component1(
      IconData icon, String hintText, bool isPassword, bool isEmail) {
    Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: 10,
          sigmaX: 10,
        ),
        child: Container(
          height: size.width / 8,
          width: size.width / 1.2,
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: size.width / 30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.05),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextFormField(
            style: TextStyle(color: Colors.white.withOpacity(1), fontSize: 20),
            cursorColor: Colors.white,
            obscureText: isPasswordVisible,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: Colors.white.withOpacity(1),
              ),
              border: InputBorder.none,
              hintMaxLines: 1,
              hintText: hintText,
              hintStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white.withOpacity(1),
                  fontWeight: FontWeight.bold),
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (isPasswordVisible) {
                      setState(() {
                        isPasswordVisible = false;
                      });
                    } else {
                      setState(() {
                        isPasswordVisible = true;
                      });
                    }
                  },
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            onChanged: (value) {
              _password = value.trim();
            },
            /* validator: isPassword
                ? null
                : (email) => email != null && !EmailValidator.validate(email)
                    ? 'Enter a valid Email'
                    : null, */
          ),
        ),
      ),
    );
  }

  Widget component2(String string, double width, VoidCallback voidCallback) {
    Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: voidCallback,
          child: Container(
            height: size.width / 8,
            width: size.width / width,
            alignment: Alignment.center,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Text(
                string,
                style: TextStyle(
                    color: Colors.white.withOpacity(1),
                    fontWeight: FontWeight.bold),
              ),
            ),
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

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
