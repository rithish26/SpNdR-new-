import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure/searchservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import 'anime.dart';

class Chart extends StatefulWidget {
  String refid;
  Chart(this.refid);
  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> with TickerProviderStateMixin {
  late List<SalesData> _chartData;
  late List<SalesData> _chartData2;
  late List<GDPData> _chartData3;
  late TooltipBehavior _tooltipBehavior;
  bool hello = false;
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
    _chartData3 = getChartData3();
    _chartData = getChartData();
    _chartData2 = getChartData2();
    _tooltipBehavior = TooltipBehavior(enable: false);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  late String valuee = new DateFormat('MMM').format(new DateTime.now());

  var queryResultSet = [];
  var tempsearchstore = [];
  void initiate() {
    SearchService().searchByt(widget.refid).then((QuerySnapshot docse) async {
      for (int i = 0; i < docse.docs.length; ++i) {
        if (docse.docs[i].data()['isincome'])
          _chartData.add(SalesData(
              docse.docs[i].data()['date'], docse.docs[i].data()['amount']));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Analytics'),
        brightness: Brightness.light,
        /*  actions: [
          IconButton(
              onPressed: () {
                if (hello) {
                  setState(() {
                    hello = false;
                  });
                } else {
                  setState(() {
                    hello = true;
                  });
                }
              },
              icon: Icon(
                Icons.import_export,
                color: Colors.green,
                size: 30,
              ))
        ], */
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
                  Padding(
                      padding: EdgeInsets.only(
                          left: 15, top: 10, bottom: 0, right: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text(
                            'Monthly Analytics',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, top: 10, bottom: 20, right: 10),
                            child: Container(
                              padding: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  elevation: 0,
                                  dropdownColor: Color(0xFFF5F5F5),
                                  hint: Text('$valuee'),
                                  items: <String>[
                                    'Jan',
                                    'Feb',
                                    'Mar',
                                    'Apr',
                                    'May',
                                    'Jun',
                                    'Jul',
                                    'Aug',
                                    'Sep',
                                    'Oct',
                                    'Nov',
                                    'Dec'
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  onChanged: (valueee) {
                                    setState(() {
                                      valuee = valueee!;
                                      _chartData2 = getChartData2();
                                      _chartData = getChartData();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 0, right: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: Text(
                                        'Income:',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  )),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10.0, right: 10),
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, top: 10, bottom: 0, right: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: Text(
                                        'Expense:',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  )),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10.0, right: 10),
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 10, bottom: 20, right: 10),
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaY: 30,
                          sigmaX: 30,
                        ),
                        child: Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: SfCartesianChart(
                            title: ChartTitle(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              text: 'Income/Expense Spline Chart',
                            ),
                            tooltipBehavior: _tooltipBehavior,
                            series: <ChartSeries>[
                              SplineSeries<SalesData, double>(
                                  name: 'Income',
                                  color: Colors.red,
                                  dataSource: _chartData2,
                                  xValueMapper: (SalesData sales, _) =>
                                      sales.year,
                                  yValueMapper: (SalesData sales, _) =>
                                      sales.sales,
                                  xAxisName: 'Amount',
                                  yAxisName: 'Date',
                                  dataLabelSettings: DataLabelSettings(
                                      isVisible: true, color: Colors.blue),
                                  enableTooltip: true),
                              SplineSeries<SalesData, double>(
                                  name: 'Income',
                                  color: Colors.green,
                                  dataSource: _chartData,
                                  xValueMapper: (SalesData sales, _) =>
                                      sales.year,
                                  yValueMapper: (SalesData sales, _) =>
                                      sales.sales,
                                  xAxisName: 'Amount',
                                  yAxisName: 'Date',
                                  dataLabelSettings: DataLabelSettings(
                                      isVisible: true, color: Colors.blue),
                                  enableTooltip: true),
                            ],
                            primaryXAxis: NumericAxis(
                              edgeLabelPlacement: EdgeLabelPlacement.shift,
                              interval: 1,
                              decimalPlaces: 0,
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            primaryYAxis: NumericAxis(
                              labelFormat: '{value}Rs',
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 10, bottom: 20, right: 10),
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaY: 30,
                          sigmaX: 30,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: SfCircularChart(
                            palette: <Color>[Colors.green, Colors.redAccent],
                            title: ChartTitle(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                text: 'Income/Expense Pie chart'),
                            legend: Legend(
                                iconBorderColor: Colors.blue,
                                isVisible: true,
                                backgroundColor: Colors.white,
                                overflowMode: LegendItemOverflowMode.wrap),
                            tooltipBehavior: _tooltipBehavior,
                            series: <CircularSeries>[
                              DoughnutSeries<GDPData, String>(
                                dataSource: _chartData3,
                                xValueMapper: (GDPData data, _) =>
                                    data.continent,
                                yValueMapper: (GDPData data, _) => data.gdp,
                                dataLabelSettings: DataLabelSettings(
                                    isVisible: true, color: Colors.white),
                                enableTooltip: true,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<SalesData> getChartData() {
    final List<SalesData> chartData = [];
    print(valuee);
    int ind = 0;
    FirebaseFirestore.instance
        .collection('userdata')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('Sheets')
        .doc(widget.refid)
        .collection('Transactions')
        .where('month', isEqualTo: valuee)
        .orderBy('time', descending: true)
        .get()
        .then((QuerySnapshot docse) {
      for (int i = 0; i < docse.docs.length; ++i) {
        if (docse.docs[i].data()['isincome']) {
          if (ind > 0 &&
              double.parse(docse.docs[i].data()['date']) ==
                  chartData[ind - 1].year) {
            setState(() {
              chartData[ind - 1].sales +=
                  double.parse(docse.docs[i].data()['amount']);
            });
          } else {
            setState(() {
              chartData.add(SalesData(
                  double.parse(docse.docs[i].data()['date']),
                  double.parse(docse.docs[i].data()['amount'])));
              ind++;
            });
          }
        }
      }
    });

    return chartData;
  }

  List<SalesData> getChartData2() {
    final List<SalesData> chartData = [];
    print(valuee);
    int ind = 0;
    FirebaseFirestore.instance
        .collection('userdata')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('Sheets')
        .doc(widget.refid)
        .collection('Transactions')
        .where('month', isEqualTo: valuee)
        .orderBy('time', descending: true)
        .get()
        .then((QuerySnapshot docse) {
      for (int i = 0; i < docse.docs.length; ++i) {
        if (!docse.docs[i].data()['isincome']) {
          if (ind > 0 &&
              double.parse(docse.docs[i].data()['date']) ==
                  chartData[ind - 1].year) {
            setState(() {
              chartData[ind - 1].sales +=
                  double.parse(docse.docs[i].data()['amount']);
            });
          } else {
            setState(() {
              chartData.add(SalesData(
                  double.parse(docse.docs[i].data()['date']),
                  double.parse(docse.docs[i].data()['amount'])));
              ind++;
            });
          }
        }
      }
    });

    return chartData;
  }

  List<GDPData> getChartData3() {
    final List<GDPData> chartData = [];
    late int income;
    late int expense;
    FirebaseFirestore.instance
        .collection('userdata')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('Sheets')
        .doc(widget.refid)
        .get()
        .then((value) {
      setState(() {
        chartData.add(GDPData('Income', value['income']));
        chartData.add(GDPData('Expense', value['expense']));
      });
    });

    return chartData;
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final year;
  double sales;
}

class GDPData {
  GDPData(this.continent, this.gdp);
  final String continent;
  final int gdp;
}
