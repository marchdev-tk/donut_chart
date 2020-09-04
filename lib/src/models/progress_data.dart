// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';

@immutable
class ProgressData {
  const ProgressData({
    this.backgroundColor,
    this.sectionColor,
    this.shadowColor,
    this.shadowElevation = 4,
    this.strokeWidth = 3,
  });

  final Color backgroundColor;
  final Color sectionColor;
  final Color shadowColor;
  final double shadowElevation;
  final double strokeWidth;

  ProgressData copyWith({
    Color backgroundColor,
    Color sectionColor,
    Color shadowColor,
    double shadowElevation,
    double strokeWidth,
  }) =>
      ProgressData(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        sectionColor: sectionColor ?? this.sectionColor,
        shadowColor: shadowColor ?? this.shadowColor,
        shadowElevation: shadowElevation ?? this.shadowElevation,
        strokeWidth: strokeWidth ?? this.strokeWidth,
      );

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    return other is ProgressData &&
        backgroundColor == other.backgroundColor &&
        sectionColor == other.sectionColor &&
        shadowColor == other.shadowColor &&
        shadowElevation == other.shadowElevation &&
        strokeWidth == other.strokeWidth;
  }

  @override
  String toString() {
    return '''
    {
      backgroundColor: $backgroundColor,
      sectionColor: $sectionColor,
      shadowColor: $shadowColor,
      shadowElevation: $shadowElevation,
      strokeWidth: $strokeWidth
    }''';
  }
}