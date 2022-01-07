import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:expenditure/dash.dart';
import 'package:expenditure/reset.dart';
import 'package:expenditure/signup.dart';
import 'package:expenditure/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email = "";
  String _password = "";
  final auth = FirebaseAuth.instance;
  final formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
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

  bool isPasswordVisible = true;
  ontap() {}
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
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
          ),
        ),
        title: Center(child: Text('Login')),
      ),
      body: Form(
        key: formkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(),
              Container(
                height: 270.0,
                width: 300.0,
                padding: EdgeInsets.only(top: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Center(
                  child: Image.asset('assets/download.png'),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {},
                        icon: Icon(Icons.email),
                        color: Colors.black,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(20),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'E-mail Id',
                    labelStyle: TextStyle(color: Colors.black),
                    hintText: 'Eg. johndow@gmail.com',
                    hintStyle: TextStyle(fontSize: 20.0, color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _email = value.trim();
                    });
                  },
                  validator: (_email) =>
                      _email != null && !EmailValidator.validate(_email)
                          ? 'Enter a valid Email'
                          : null,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  textInputAction: TextInputAction.next,
                  obscureText: isPasswordVisible,
                  decoration: InputDecoration(
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
                          isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.all(20),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.black),
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(fontSize: 20.0, color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _password = value.trim();
                    });
                  },
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              isloading
                  ? Center(
                      child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ))
                  : Container(
                      height: 50,
                      width: 300,
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
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20)),
                      child: TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.black12,
                          ),
                        ),
                        onPressed: () async {
                          try {
                            {
                              final form = formkey.currentState!;
                              if (form.validate()) {
                                setState(() {
                                  isloading = true;
                                });
                                await auth.signInWithEmailAndPassword(
                                    email: _email, password: _password);
                                final usere = auth.currentUser;
                                var collection = FirebaseFirestore.instance
                                    .collection('userdata');
                                var docSnapshot =
                                    await collection.doc(usere.uid).get();

                                if (usere != null && docSnapshot.exists) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => Dash()));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Welcome back'),
                                    ),
                                  );

                                  setState(() {
                                    isloading = false;
                                  });
                                } else if (!docSnapshot.exists) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VerifyScreen()),
                                    (Route<dynamic> route) => false,
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialog(
                                            context, "Not verified mail id"),
                                  );

                                  setState(() {
                                    isloading = false;
                                  });
                                }
                              }
                            }
                          } catch (e) {
                            print(e);

                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialog(
                                      context, "wrong password or mail id"),
                            );
                            setState(() {
                              isloading = false;
                            });
                          }
                        },
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
              /* Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color(0xff7c94b6),
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final form = formkey.currentState!;
                      if (form.validate()) {
                        final user = await auth.signInWithEmailAndPassword(
                            email: _email, password: _password);
                        if (user != null) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => JobSearch()));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Wrong password or username'),
                          ));
                        }
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ),
                ),
              ), */
              SizedBox(
                height: 10.0,
              ),
              /* Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      if (_email == admin_email &&
                          _password == admin_password) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => JobList()));
                      } else {
                        final form = formkey.currentState!;
                        if (form.validate()) {
                          final user = await auth.signInWithEmailAndPassword(
                              email: _email, password: _password);
                          if (user != null) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) => JobSearch()));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Wrong password or username'),
                            ));
                          }
                        }
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text(
                    'Admin Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ), */
              TextButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ResetScreen())),
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              /*  SizedBox(
                height: 15.0,
              ), */
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: Text(
                  'New User ? Create Account',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}

Widget _buildPopupDialog(BuildContext context, String text) {
  return new AlertDialog(
    title: Text('Error',
        style: TextStyle(
            color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold)),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("$text",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ],
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Close',
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    ],
  );
}
