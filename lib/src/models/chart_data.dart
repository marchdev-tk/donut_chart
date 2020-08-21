// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';

@immutable
class ChartData {
  const ChartData({
    this.sectionColor,
    this.shadowColor,
    this.shadowElevation = 4,
    this.strokeColor,
    this.strokeGradient,
    this.strokeSelectedColor,
    this.strokeSelectedGradient,
    this.outerStrokeWidth = 1.5,
    this.outerSelectedStrokeWidth = 0,
    this.innerStrokeWidth = 1.5,
    this.innerSelectedStrokeWidth = 3.5,
  });

  const ChartData.borderless({
    this.sectionColor,
    this.shadowColor,
    this.shadowElevation = 4,
  })  : strokeColor = null,
        strokeGradient = null,
        strokeSelectedColor = null,
        strokeSelectedGradient = null,
        outerStrokeWidth = null,
        outerSelectedStrokeWidth = null,
        innerStrokeWidth = null,
        innerSelectedStrokeWidth = null;

  final Color sectionColor;
  final Color shadowColor;
  final double shadowElevation;

  final Color strokeColor;
  final Gradient strokeGradient;

  final Color strokeSelectedColor;
  final Gradient strokeSelectedGradient;

  final double outerStrokeWidth;
  final double outerSelectedStrokeWidth;
  final double innerStrokeWidth;
  final double innerSelectedStrokeWidth;

  bool hasInnerBorder() {
    return (strokeColor != null || strokeGradient != null) &&
        (strokeSelectedColor != null || strokeSelectedGradient != null) &&
        innerStrokeWidth != null &&
        innerSelectedStrokeWidth != null;
  }

  bool hasOuterBorder() {
    return (strokeColor != null || strokeGradient != null) &&
        (strokeSelectedColor != null || strokeSelectedGradient != null) &&
        outerStrokeWidth != null &&
        outerSelectedStrokeWidth != null;
  }

  ChartData copyWith({
    Color sectionColor,
    Color shadowColor,
    double shadowElevation,
    Color strokeColor,
    Gradient strokeGradient,
    Color strokeSelectedColor,
    Gradient strokeSelectedGradient,
    Gradient backgroundGradient,
    double outerStrokeWidth,
    double outerSelectedStrokeWidth,
    double innerStrokeWidth,
    double innerSelectedStrokeWidth,
  }) =>
      ChartData(
        sectionColor: sectionColor ?? this.sectionColor,
        shadowColor: shadowColor ?? this.shadowColor,
        shadowElevation: shadowElevation ?? this.shadowElevation,
        strokeColor: strokeColor ?? this.strokeColor,
        strokeGradient: strokeGradient ?? this.strokeGradient,
        strokeSelectedColor: strokeSelectedColor ?? this.strokeSelectedColor,
        strokeSelectedGradient:
            strokeSelectedGradient ?? this.strokeSelectedGradient,
        outerStrokeWidth: outerStrokeWidth ?? this.outerStrokeWidth,
        outerSelectedStrokeWidth:
            outerSelectedStrokeWidth ?? this.outerSelectedStrokeWidth,
        innerStrokeWidth: innerStrokeWidth ?? this.innerStrokeWidth,
        innerSelectedStrokeWidth:
            innerSelectedStrokeWidth ?? this.innerSelectedStrokeWidth,
      );

  @override
  String toString() {
    return '''
    {
      sectionColor: $sectionColor,
      shadowColor: $shadowColor,
      shadowElevation: $shadowElevation,
      strokeColor: $strokeColor,
      strokeGradient: $strokeGradient,
      strokeSelectedColor: $strokeSelectedColor,
      strokeSelectedGradient: $strokeSelectedGradient,
      outerStrokeWidth: $outerStrokeWidth,
      outerSelectedStrokeWidth: $outerSelectedStrokeWidth,
      innerStrokeWidth: $innerStrokeWidth,
      innerSelectedStrokeWidth: $innerSelectedStrokeWidth
    }''';
  }
}
