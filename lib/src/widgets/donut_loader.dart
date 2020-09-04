// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' show pi;

import 'package:flutter/widgets.dart';

import '../donut_painter.dart';

@immutable
class DonutChartLoader extends StatefulWidget {
  const DonutChartLoader({
    Key key,
    @required this.data,
  }) : super(key: key);

  final ChartData data;

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
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: constraints.maxWidth,
          height: constraints.maxWidth,
          child: ValueListenableBuilder<double>(
            valueListenable: _animation,
            builder: (context, snapshot, child) {
              return Transform.rotate(
                angle: -0.5 * pi + snapshot,
                child: CustomPaint(
                  isComplex: true,
                  painter: DonutLoadingPainter(
                    data: widget.data,
                  ),
                  child: child,
                ),
              );
            },
            child: SizedBox.fromSize(
              size: Size.square(constraints.maxWidth),
            ),
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
