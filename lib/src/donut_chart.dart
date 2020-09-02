// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' show max, pi;

import 'package:flutter/widgets.dart';

import 'donut_painter.dart';

@immutable
class DonutChart extends StatefulWidget {
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
  _DonutChartState createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart>
    with SingleTickerProviderStateMixin {
  AnimationController _valueController;
  Animation<double> _valueAnimation;

  List<double> _oldValues;
  int _oldSelectedIndex;

  bool get _needAnimateValue {
    if ((_oldValues?.length ?? 0) != widget.sections.length) {
      return true;
    }

    for (var i = 0; i < _oldValues.length; i++) {
      if (_oldValues[i] != widget.sections[i].value) {
        return true;
      }
    }

    return false;
  }

  void _onSectionTapped(value) {
    widget.onSectionTapped(value);
    _valueController.forward(from: 0);
  }

  void _initValueController() {
    _valueController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _valueAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _valueController,
      curve: Curves.easeInOut,
    ));

    if (_needAnimateValue) {
      _valueController.forward(from: 0);
    }
  }

  @override
  void initState() {
    _initValueController();
    super.initState();
  }

  @override
  void didUpdateWidget(DonutChart oldWidget) {
    _oldValues = oldWidget.sections.map((s) => s.value).toList();
    _oldSelectedIndex = oldWidget.sections.indexOfSelected;
    if (_needAnimateValue) {
      _valueController.forward(from: 0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.5 * pi,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: constraints.maxWidth,
            height: constraints.maxWidth,
            child: ValueListenableBuilder<double>(
              valueListenable: _valueAnimation,
              builder: (context, valueCoef, child) {
                return Builder(
                  key: ValueKey(_valueAnimation.value),
                  builder: (context) {
                    List<Section> sections = [];
                    final oldValuesLength = _oldValues?.length ?? 0;
                    final length = max(widget.sections.length, oldValuesLength);
                    for (var i = 0; i < length; i++) {
                      final section = widget.sections.length > i
                          ? widget.sections[i]
                          : const Section(value: 0);
                      final oldValue = oldValuesLength > i ? _oldValues[i] : 0;
                      final value =
                          oldValue + (section.value - oldValue) * valueCoef;
                      sections.add(section.copyWith(
                        value: value,
                      ));
                    }

                    final prevStart =
                        sections.sumValuesBeforeIndex(_oldSelectedIndex ?? 0);
                    final prevValue =
                        _oldSelectedIndex != null && _oldValues != null
                            ? _oldValues[_oldSelectedIndex]
                            : 0;
                    final prevEnd = prevStart + prevValue;

                    final selectedIndex = sections.indexOfSelected;
                    final selectedStart =
                        sections.sumValuesBeforeIndex(selectedIndex);
                    final selectedValue =
                        selectedIndex != -1 && sections != null
                            ? sections[selectedIndex].value
                            : 0;
                    final selectedEnd = selectedStart + selectedValue;

                    final newStart =
                        prevStart + (selectedStart - prevStart) * valueCoef;
                    final newEnd =
                        prevEnd + (selectedEnd - prevEnd) * valueCoef;

                    return CustomPaint(
                      isComplex: true,
                      painter: DonutPainter(
                        data: widget.data,
                        selectedStartValue: newStart,
                        selectedEndValue: newEnd,
                        sections: sections ?? widget.sections,
                        onSectionTapped: widget.onSectionTapped != null
                            ? _onSectionTapped
                            : null,
                      ),
                      child: child,
                    );
                  },
                );
              },
              child: SizedBox.fromSize(
                size: Size.square(constraints.maxWidth),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }
}

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
