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
  final _chartData = ChartData(
    backgroundColor: Colors.white24,
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
  );
  var _sections = <Section>[
    Section(value: 0.34, selected: true),
    Section(value: 0.21),
    Section(value: 0.25),
    Section(value: 0.20),
  ];
  var _startValue = .0;
  var _value = 0.7;

  int index = 0;
  Iterable<List<Section>> getData() sync* {
    yield [
      Section(value: 0.44, selected: true),
      Section(value: 0.11),
      Section(value: 0.15),
      Section(value: 0.30),
    ];

    yield [
      Section(value: 0.24),
      Section(value: 0.31, selected: true),
      Section(value: 0.45),
    ];

    yield [
      Section(value: 0.34),
      Section(value: 0.21),
      Section(value: 0.25, selected: true),
      Section(value: 0.20),
    ];
  }

  Iterable<List<double>> getProgress() sync* {
    yield [
      0.3,
      0.5,
    ];

    yield [
      0.7,
      0.3,
    ];

    yield [
      0,
      0.7,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('donut_chart Demo'),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Change sections',
        onPressed: () {
          setState(() => _sections = getData().elementAt(index));
          index = (index + 1) % 3;
        },
        child: Icon(Icons.edit),
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.blueGrey[900],
            child: DonutChart(
              data: _chartData,
              sections: _sections,
              onSectionTapped: (value) =>
                  setState(() => _sections = _sections.copyWithSelected(value)),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DonutProgress(
                  data: ProgressData(
                    backgroundColor: Colors.grey[300],
                    sectionColor: Colors.blue,
                    shadowColor: Colors.blue,
                    shadowElevation: 2,
                  ),
                  startValue: _startValue,
                  value: _value,
                  size: 56,
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      final data = getProgress().elementAt(index);
                      _startValue = data.first;
                      _value = data.last;
                    });
                    index = (index + 1) % 3;
                  },
                  mini: true,
                  child: Icon(Icons.edit),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.blueGrey[800],
            child: DonutChartLoader(
              data: _chartData,
            ),
          ),
        ],
      ),
    );
  }
}
