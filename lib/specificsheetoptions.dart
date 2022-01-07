import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/searchservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SpecificSheet extends StatefulWidget {
  String sheetname = "";
  String sheetId = "";
  String refid = "";
  SpecificSheet(
      {required this.sheetname, required this.sheetId, required this.refid});

  @override
  _SpecificSheetState createState() => _SpecificSheetState();
}

class _SpecificSheetState extends State<SpecificSheet> {
  var queryResultSet = [];
  var tempsearchstore = [];

  initiateSearch() {
    queryResultSet = [];
    tempsearchstore = [];

    FirebaseFirestore.instance
        .collection('USERS')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('sheetids')
        .doc(widget.refid)
        .collection('Sheets')
        .get()
        .then((QuerySnapshot docse) {
      for (int i = 0; i < docse.docs.length; ++i) {
        queryResultSet.add(docse.docs[i].data());
        setState(() {
          print(queryResultSet[i]);
          tempsearchstore.add(queryResultSet[i]);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initiateSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        widget.sheetname,
      )),
      body: ListView(
          padding: EdgeInsets.all(20),
          primary: true,
          shrinkWrap: true,
          children: tempsearchstore.reversed.map((element) {
            return buildResultCard(context, element);
          }).toList()),
    );
  }
}

Widget buildResultCard(BuildContext context, data) {
  return SingleChildScrollView(
    child: Column(
      children: [
        GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              height: 50,
              child: Center(
                  child: Text(data['Sheetname'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ))),
            ),
            onTap: () {
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
        SizedBox(
          height: 10.0,
        ),
      ],
    ),
  );
}
