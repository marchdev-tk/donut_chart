// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';

@immutable
class ChartData {
  const ChartData({
    this.backgroundColor,
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
    this.backgroundColor,
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

  final Color backgroundColor;

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
    Color backgroundColor,
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
        backgroundColor: backgroundColor ?? this.backgroundColor,
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
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    return other is ChartData &&
        backgroundColor == other.backgroundColor &&
        sectionColor == other.sectionColor &&
        shadowColor == other.shadowColor &&
        shadowElevation == other.shadowElevation &&
        strokeColor == other.strokeColor &&
        strokeGradient == other.strokeGradient &&
        strokeSelectedColor == other.strokeSelectedColor &&
        strokeSelectedGradient == other.strokeSelectedGradient &&
        outerStrokeWidth == other.outerStrokeWidth &&
        outerSelectedStrokeWidth == other.outerSelectedStrokeWidth &&
        innerStrokeWidth == other.innerStrokeWidth &&
        innerSelectedStrokeWidth == other.innerSelectedStrokeWidth;
  }

  @override
  String toString() {
    return '''
    {
      backgroundColor: $backgroundColor,
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
