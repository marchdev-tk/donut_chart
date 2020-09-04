// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' show pi;

import 'package:flutter/widgets.dart';

import '../donut_painter.dart';

@immutable
class DonutProgress extends StatefulWidget {
  const DonutProgress({
    Key key,
    @required this.data,
    @required this.value,
    this.startValue = 0,
    this.size = 48,
  }) : super(key: key);

  final ProgressData data;
  final double startValue;
  final double value;
  final double size;

  @override
  _DonutProgressState createState() => _DonutProgressState();
}

class _DonutProgressState extends State<DonutProgress>
    with SingleTickerProviderStateMixin {
  AnimationController _valueController;
  Animation<double> _valueAnimation;

  double _oldStartValue = 0;
  double _oldValue = 0;

  void _initValueController() {
    _valueController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _valueAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _valueController,
      curve: Curves.easeInOut,
    ));

    _valueController.forward(from: 0);
  }

  @override
  void initState() {
    _initValueController();
    super.initState();
  }

  @override
  void didUpdateWidget(DonutProgress oldWidget) {
    _oldStartValue = oldWidget.startValue;
    _oldValue = oldWidget.value;

    _valueController.forward(from: 0);

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.5 * pi,
      child: SizedBox(
        width: widget.size + widget.data.shadowElevation,
        height: widget.size + widget.data.shadowElevation,
        child: ValueListenableBuilder<double>(
          valueListenable: _valueAnimation,
          builder: (context, valueCoef, child) {
            return Builder(
              key: ValueKey(_valueAnimation.value),
              builder: (context) {
                final start = _oldStartValue +
                    (widget.startValue - _oldStartValue) * valueCoef;
                final value =
                    _oldValue + (widget.value - _oldValue) * valueCoef;

                return CustomPaint(
                  isComplex: true,
                  painter: DonutProgressPainter(
                    data: widget.data,
                    start: start,
                    value: value,
                  ),
                  child: child,
                );
              },
            );
          },
          child: SizedBox.fromSize(
            size: Size.square(widget.size + widget.data.shadowElevation),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }
}
