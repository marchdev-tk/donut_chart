// Copyright (c) 2021, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../donut_painter.dart';

extension SectionListExtension on List<Section> {
  void selectByIndex(int index) {
    final sections = <Section>[];

    for (int i = 0; i < length; i++) {
      sections.add(this[i].copyWith(selected: index == i));
    }

    clear();
    addAll(sections);
  }

  List<Section> copyWithSelected(int index) {
    final sections = <Section>[];

    for (int i = 0; i < length; i++) {
      sections.add(this[i].copyWith(selected: index == i));
    }

    return sections;
  }

  double sumValuesBeforeIndex(int index) {
    return map((e) => e.value)
        .toList()
        .sublist(0, index)
        .fold<double>(0, (a, b) => a + b);
  }

  int get indexOfSelected => indexWhere((s) => s.selected);
}
