// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:donut_chart/donut_chart.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'donut_chart Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Section> _sections = [
    Section(value: 0.34, selected: true),
    Section(value: 0.21),
    Section(value: 0.25),
    Section(value: 0.20),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('donut_chart Demo'),
      ),
      body: Center(
        child: Container(
          color: Colors.blueGrey[900],
          child: DonutChart(
            data: ChartData(
              sectionColor: Colors.white,
              shadowColor: Color(0x40000000),
              strokeGradient: LinearGradient(
                tileMode: TileMode.repeated,
                colors: [
                  Color.fromRGBO(0, 0, 0, 0.0384),
                  Color.fromRGBO(255, 255, 255, 0.2376),
                ],
              ),
              strokeSelectedColor: Color(0xFFE5E7EF),
            ),
            sections: _sections,
            onSectionTapped: (value) =>
                setState(() => _sections.selectByIndex(value)),
          ),
        ),
      ),
    );
  }
}
