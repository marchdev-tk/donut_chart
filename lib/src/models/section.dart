// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';

@immutable
class Section {
  const Section({
    @required this.value,
    this.color,
    this.selected = false,
  });

  /// Must be between [0, 1].
  final double value;

  /// If set, this color will be used instead of calculated.
  final Color color;

  final bool selected;

  Section copyWith({
    double value,
    Color color,
    bool selected,
  }) =>
      Section(
        value: value ?? this.value,
        color: color ?? this.color,
        selected: selected ?? this.selected,
      );

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Section &&
        value == other.value &&
        color == other.color &&
        selected == other.selected;
  }

  @override
  String toString() => '{ value: $value, color: $color, selected: $selected }';
}
