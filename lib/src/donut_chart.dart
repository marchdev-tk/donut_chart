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
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CustomPaint(
            painter: DonutPainter(
              data: data,
              sections: sections,
              onSectionTapped: onSectionTapped,
            ),
            child: SizedBox.fromSize(
              size: Size.square(constraints.maxWidth),
            ),
          );
        },
      ),
    );
  }
}

@immutable
class DonutChartLoader extends StatefulWidget {
  const DonutChartLoader({
    Key key,
    @required this.data,
    @required this.backgroundColor,
  }) : super(key: key);

  final ChartData data;
  final Color backgroundColor;

  @override
  _DonutChartLoaderState createState() => _DonutChartLoaderState();
}

class _DonutChartLoaderState extends State<DonutChartLoader>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ValueListenableBuilder<double>(
          valueListenable: _animation,
          builder: (context, snapshot, child) {
            return Transform.rotate(
              angle: -0.5 * pi + snapshot,
              child: CustomPaint(
                painter: DonutLoadingPainter(
                  data: widget.data,
                  backgroundColor: widget.backgroundColor,
                ),
                child: child,
              ),
            );
          },
          child: SizedBox.fromSize(
            size: Size.square(constraints.maxWidth),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
