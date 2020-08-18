// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' show pi;

import 'package:flutter/widgets.dart';

import 'donut_painter.dart';

@immutable
class DonutChart extends StatelessWidget {
  const DonutChart({
    Key key,
    @required this.data,
    @required this.sections,
    this.onSectionTapped,
  }) : super(key: key);

  final ChartData data;
  final List<Section> sections;
  final ValueChanged<int> onSectionTapped;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.5 * pi,
      child: CustomPaint(
        child: SizedBox.fromSize(
          size: Size.square(MediaQuery.of(context).size.width),
        ),
        painter: DonutPainter(
          data: data,
          sections: sections,
          onSectionTapped: onSectionTapped,
        ),
      ),
    );
  }
}
