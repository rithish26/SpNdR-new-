import 'dart:async';
import 'dart:ui';

import 'package:blurry/blurry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/unnecesary/addpost.dart';
import 'package:expenditure/anime.dart';
import 'package:expenditure/unnecesary/deletesheet.dart';
import 'package:expenditure/editprofile.dart';
import 'package:expenditure/google_sheets.dart';
import 'package:expenditure/homepage.dart';
import 'package:expenditure/unnecesary/login.dart';
import 'package:expenditure/search.dart';
import 'package:expenditure/searchservice.dart';
import 'package:expenditure/specificsheetoptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

late String sheetid;
String username = "";

class Dash extends StatefulWidget {
  @override
  _DashState createState() => _DashState();
}

class _DashState extends State<Dash> with TickerProviderStateMixin {
  late AnimationController controller1;
  late AnimationController controller2;
  late Animation<double> animation1;
  late Animation<double> animation2;
  late Animation<double> animation3;
  late Animation<double> animation4;
  TextEditingController _sheetname = TextEditingController();
  var queryResultSet = [];
  var tempsearchstore = [];
  final FirebaseAuth auth = FirebaseAuth.instance;

  initiateSearch() {
    queryResultSet = [];
    tempsearchstore = [];

    SearchService().searchByName().then((QuerySnapshot docse) {
      for (int i = 0; i < docse.docs.length; ++i) {
        queryResultSet.add(docse.docs[i].data());
        setState(() {
          print(queryResultSet[i]);
          tempsearchstore.add(queryResultSet[i]);
        });
      }
    });
  }

  String userId = "";

  late User user;
  late QuerySnapshot snapshotData;
  bool isexecuted = false;
  TextEditingController searchController = TextEditingController();

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

    initiateSearch();

    getusername();
  }

  void getusername() {
    FirebaseFirestore.instance
        .collection('userdata')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        username = value['firstname'];
      });
    });
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  void setStateIfMounted(String f) {
    print(f);
    if (mounted)
      setState(() {
        sheetid = f;
      });
  }

  getdata() {
    print('dash');
    String refid = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance
        .collection('userdata')
        .doc(refid)
        .get()
        .then((value) {
      print(value['sheetid']);
      setStateIfMounted(value['sheetid']);
      /* setState(() {
        print(value['sheetid']);
        sheetid = value['sheetid'];
      }); */
    });
  }

  nonsearchdata(double x, double y) {
    return SizedBox(
      height: x,
      child: Stack(
        children: [
          Positioned(
            top: x * (animation2.value + .58),
            left: y * .21,
            child: CustomPaint(
              painter: MyPainter(50),
            ),
          ),
          Positioned(
            top: x * .98,
            left: y * .1,
            child: CustomPaint(
              painter: MyPainter(animation4.value - 30),
            ),
          ),
          Positioned(
            top: x * .5,
            left: y * (animation2.value + .8),
            child: CustomPaint(
              painter: MyPainter(30),
            ),
          ),
          Positioned(
            top: x * animation3.value,
            left: y * (animation1.value + .1),
            child: CustomPaint(
              painter: MyPainter(60),
            ),
          ),
          Positioned(
            top: x * .1,
            left: y * .8,
            child: CustomPaint(
              painter: MyPainter(animation4.value),
            ),
          ),
          ListView(
              padding: EdgeInsets.all(20),
              primary: true,
              shrinkWrap: true,
              children: tempsearchstore.map((element) {
                return buildResultCard(context, element);
              }).toList()),
        ],
      ),
    );
  }

  Widget searchedData() {
    TextEditingController name = TextEditingController();
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.all(4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaY: 50,
                sigmaX: 50,
              ),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: ListTile(
                  focusColor: Colors.green,
                  title: Center(
                    child: Text(snapshotData.docs[index].data()['sheetname'],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                  ),
                  onLongPress: () {
                    Alert(
                      style: AlertStyle(
                        backgroundColor: Color(0xff192028),
                        overlayColor: Colors.transparent,
                        animationType: AnimationType.fromTop,
                        descStyle: TextStyle(fontWeight: FontWeight.bold),
                        animationDuration: Duration(milliseconds: 400),
                        alertBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        titleStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      context: context,
                      type: AlertType.warning,
                      title: "Options",
                      desc: "",
                      content: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaY: 10,
                                sigmaX: 10,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: TextField(
                                  controller: name,
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
                                    hintText: 'Enter the Catagory Name',
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
                          ),
                        ],
                      ),
                      buttons: [
                        DialogButton(
                          child: Text(
                            "UPDATE",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () async {
                            if (name.text == "") {
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
                                      desc: "Catagory name missing")
                                  .show();
                            } else {
                              final ref = FirebaseFirestore.instance
                                  .collection('userdata')
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .collection('Sheets')
                                  .doc(
                                      snapshotData.docs[index].data()['refid']);
                              ref.update(
                                {
                                  "sheetname": name.text,
                                  "refid": ref.id,
                                  "searchkey": name.text.toLowerCase(),
                                },
                              );
                              /* final refe = FirebaseFirestore.instance
                                  .collection('USERS')
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .collection("sheetids")
                                  .doc(ref.id)
                                  .collection('Sheets')
                                  .doc();
                              refe.set(
                                  {"Sheetname": _sheetname.text, "Refid": refe.id}); */
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => Dash()),
                                (Route<dynamic> route) => false,
                              );
                            }
                          },
                          gradient: LinearGradient(colors: [
                            Colors.blue,
                            Colors.purple,
                            Colors.orange,
                          ]),
                        ),
                        DialogButton(
                          child: Text(
                            "DELETE",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            final ref = FirebaseFirestore.instance
                                .collection('userdata')
                                .doc(FirebaseAuth.instance.currentUser.uid)
                                .collection('Sheets')
                                .doc(snapshotData.docs[index].data()['refid']);
                            ref.delete();
                            /* final refe = FirebaseFirestore.instance
                                  .collection('USERS')
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .collection("sheetids")
                                  .doc(ref.id)
                                  .collection('Sheets')
                                  .doc();
                              refe.set(
                                  {"Sheetname": _sheetname.text, "Refid": refe.id}); */
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Dash()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          gradient: LinearGradient(colors: [
                            Colors.blue,
                            Colors.purple,
                            Colors.orange,
                          ]),
                        )
                      ],
                    ).show();
                    /* Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Dsheet(
                              refid: snapshotData.docs[index].data()['refid'],
                              name: snapshotData.docs[index].data()['sheetname'])),
                    ); */
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomePage(
                          refid: snapshotData.docs[index].data()['refid'],
                          sheetname:
                              snapshotData.docs[index].data()['sheetname'],
                          username: username,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
      itemCount: snapshotData.docs.length,
    );
  }

  _logOut() async {
    await FirebaseAuth.instance.signOut().then((_) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => AnimeHomePage()));
      });
      /*  Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    }); */
    });
  }

  var alertStyle = AlertStyle(
    backgroundColor: Color(0xff192028),
    overlayColor: Colors.transparent,
    animationType: AnimationType.fromTop,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
      side: BorderSide(
        color: Colors.white,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.white,
    ),
  );
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff192028),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(
            Icons.add,
            color: Colors.orange,
            size: 30.0,
          ),
          onPressed: () {
            Alert(
                context: context,
                title: "N E W   C A T A G O R Y",
                style: alertStyle,
                content: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaY: 10,
                          sigmaX: 10,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            controller: _sheetname,
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
                              hintText: 'Enter the Catagory Name',
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
                    ),
                  ],
                ),
                buttons: [
                  DialogButton(
                    onPressed: () async {
                      if (_sheetname.text == "") {
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
                                desc: "Catagory name missing")
                            .show();
                        /*  showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialog(context, "Sheetname empty"),
                          ); */
                      } else {
                        final ref = FirebaseFirestore.instance
                            .collection('userdata')
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .collection('Sheets')
                            .doc();
                        ref.set({
                          "sheetname": _sheetname.text,
                          "refid": ref.id,
                          "searchkey": _sheetname.text.toLowerCase(),
                          "expense": 0,
                          "income": 0,
                          "total": 0,
                        });

                        /* final refe = FirebaseFirestore.instance
                            .collection('USERS')
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .collection("sheetids")
                            .doc(ref.id)
                            .collection('Sheets')
                            .doc();
                        refe.set(
                            {"Sheetname": _sheetname.text, "Refid": refe.id}); */
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Dash()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    gradient: LinearGradient(colors: [
                      Colors.blue,
                      Colors.purple,
                      Colors.orange,
                    ]),
                  )
                ]).show();
            /*  Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Addsheet(
                        sheetid: sheetid,
                      )),
            ); */
            /*  Blurry.info(
                title: 'Tip',
                description: 'Double Tap on sheet for more options',
                confirmButtonText: '',
                onConfirmButtonPressed: () {
                  print('hello world');
                }).show(context); */
          },
        ),
        appBar: AppBar(
          flexibleSpace: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            GetBuilder<DataController>(
                init: DataController(),
                builder: (val) {
                  return IconButton(
                      onPressed: () {
                        val
                            .queryData(searchController.text.toLowerCase())
                            .then((value) {
                          snapshotData = value;
                          setState(() {
                            isexecuted = true;
                          });
                        });
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ));
                }),
            IconButton(
              onPressed: () {
                searchController.clear();
                setState(() {
                  isexecuted = false;
                });
              },
              icon: Icon(Icons.clear),
              color: Colors.white,
            ),
          ],
          title: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaY: 10,
              sigmaX: 10,
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                cursorColor: Colors.white,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                decoration: InputDecoration(
                    hintText: 'Search Catagory',
                    hintStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                controller: searchController,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          brightness: Brightness.light,
        ),
        body: isexecuted
            ? SizedBox(
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
                    searchedData(),
                  ],
                ))
            : nonsearchdata(size.height, size.width),
        /* ListView(
          padding: EdgeInsets.all(20),
          primary: true,
          shrinkWrap: true,
          children: tempsearchstore.reversed.map((element) {
            return buildResultCard(context, element); 
          }).toList()),*/
        bottomNavigationBar: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaY: 100,
              sigmaX: 100,
            ),
            child: BottomAppBar(
              shape: CircularNotchedRectangle(),
              color: Colors.black,
              child: IconTheme(
                data: IconThemeData(
                    color: Theme.of(context).colorScheme.onPrimary),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      tooltip: 'Log out',
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.blue,
                        size: 30,
                      ),
                      onPressed: () {
                        _logOut();
                      },
                    ),
                    /* IconButton(
                      tooltip: 'Add',
                      icon: const Icon(
                        Icons.add,
                        color: Colors.orange,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Addsheet(
                                    sheetid: sheetid,
                                  )),
                        );
                      },
                    ), */
                    IconButton(
                      tooltip: 'Edit Profile',
                      icon: const Icon(
                        Icons.account_box,
                        color: Colors.purple,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Editp(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

Widget buildResultCard(BuildContext context, data) {
  TextEditingController name = TextEditingController();
  name.text = data['sheetname'];
  return SingleChildScrollView(
    child: Column(
      children: [
        Tooltip(
          message: 'Longpress for more options',
          child: GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaY: 50,
                    sigmaX: 50,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    height: 100,
                    child: Center(
                        child: Text(data['sheetname'],
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ))),
                  ),
                ),
              ),
              onLongPress: () {
                Alert(
                  style: AlertStyle(
                    backgroundColor: Color(0xff192028),
                    overlayColor: Colors.transparent,
                    animationType: AnimationType.fromTop,
                    descStyle: TextStyle(fontWeight: FontWeight.bold),
                    animationDuration: Duration(milliseconds: 400),
                    alertBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    titleStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  context: context,
                  type: AlertType.warning,
                  title: "Options",
                  desc: "",
                  content: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaY: 10,
                            sigmaX: 10,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: TextField(
                              controller: name,
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
                                hintText: 'Enter the Catagory Name',
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
                      ),
                    ],
                  ),
                  buttons: [
                    DialogButton(
                      child: Text(
                        "UPDATE",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () async {
                        if (name.text == "") {
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
                                  desc: "Catagory name missing")
                              .show();
                        } else {
                          final ref = FirebaseFirestore.instance
                              .collection('userdata')
                              .doc(FirebaseAuth.instance.currentUser.uid)
                              .collection('Sheets')
                              .doc(data['refid']);
                          ref.update(
                            {
                              "sheetname": name.text,
                              "refid": ref.id,
                              "searchkey": name.text.toLowerCase(),
                            },
                          );
                          /* final refe = FirebaseFirestore.instance
                              .collection('USERS')
                              .doc(FirebaseAuth.instance.currentUser.uid)
                              .collection("sheetids")
                              .doc(ref.id)
                              .collection('Sheets')
                              .doc();
                          refe.set(
                              {"Sheetname": _sheetname.text, "Refid": refe.id}); */
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Dash()),
                            (Route<dynamic> route) => false,
                          );
                        }
                      },
                      gradient: LinearGradient(colors: [
                        Colors.blue,
                        Colors.purple,
                        Colors.orange,
                      ]),
                    ),
                    DialogButton(
                      child: Text(
                        "DELETE",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        final ref = FirebaseFirestore.instance
                            .collection('userdata')
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .collection('Sheets')
                            .doc(data['refid']);
                        ref.delete();
                        /* final refe = FirebaseFirestore.instance
                              .collection('USERS')
                              .doc(FirebaseAuth.instance.currentUser.uid)
                              .collection("sheetids")
                              .doc(ref.id)
                              .collection('Sheets')
                              .doc();
                          refe.set(
                              {"Sheetname": _sheetname.text, "Refid": refe.id}); */
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Dash()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      gradient: LinearGradient(colors: [
                        Colors.blue,
                        Colors.purple,
                        Colors.orange,
                      ]),
                    )
                  ],
                ).show();
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(
                      refid: data['refid'],
                      sheetname: data['sheetname'],
                      username: username,
                    ),
                  ),
                );

                /*  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobApply(
                      jobtitle: data['jobtitle'],
                      jobdisc: data['jobdisc'],
                      qualification: data['qualification'],
                      websitelink: data['websitelink'],
                      isadmin: true,
                      companyname: data['companyname'],
                      refid: data['refid'],
                      email: data['email link'],
                      aboutcompany: data['about company'],
                      isprev: false,
                    ),
                  ),
                ); */
              }),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    ),
  );
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
