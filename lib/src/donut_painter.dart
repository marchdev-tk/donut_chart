// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' show pi, sin, cos, Point;

import 'package:flutter/widgets.dart';

import 'models/section.dart';
import 'models/chart_data.dart';
import 'utils/section_utils.dart';

export 'models/section.dart';
export 'models/chart_data.dart';
export 'utils/section_utils.dart';

Path _draw({
  Canvas canvas,
  Point center,
  double radius,
  double innerRadius,
  double startAngle,
  double endAngle,
  Color fill,
  Shader shader,
}) {
  final paint = Paint();

  if (fill != null && shader == null) {
    paint.color = Color.fromARGB(fill.alpha, fill.red, fill.green, fill.blue);
  }
  paint.shader = shader;
  paint.style = PaintingStyle.fill;

  final innerRadiusStartPoint = Point<double>(
      innerRadius * cos(startAngle) + center.x,
      innerRadius * sin(startAngle) + center.y);

  final innerRadiusEndPoint = Point<double>(
      innerRadius * cos(endAngle) + center.x,
      innerRadius * sin(endAngle) + center.y);

  final radiusStartPoint = Point<double>(
      radius * cos(startAngle) + center.x, radius * sin(startAngle) + center.y);

  final centerOffset = Offset(center.x, center.y);

  final isFullCircle =
      startAngle != null && endAngle != null && endAngle - startAngle == 2 * pi;

  final midpointAngle = (endAngle + startAngle) / 2;

  final path = Path()..moveTo(innerRadiusStartPoint.x, innerRadiusStartPoint.y);

  path.lineTo(radiusStartPoint.x, radiusStartPoint.y);

  // For full circles, draw the arc in two parts.
  if (isFullCircle) {
    path.arcTo(Rect.fromCircle(center: centerOffset, radius: radius),
        startAngle, midpointAngle - startAngle, true);
    path.arcTo(Rect.fromCircle(center: centerOffset, radius: radius),
        midpointAngle, endAngle - midpointAngle, true);
  } else {
    path.arcTo(Rect.fromCircle(center: centerOffset, radius: radius),
        startAngle, endAngle - startAngle, true);
  }

  path.lineTo(innerRadiusEndPoint.x, innerRadiusEndPoint.y);

  // For full circles, draw the arc in two parts.
  if (isFullCircle) {
    path.arcTo(Rect.fromCircle(center: centerOffset, radius: innerRadius),
        endAngle, midpointAngle - endAngle, true);
    path.arcTo(Rect.fromCircle(center: centerOffset, radius: innerRadius),
        midpointAngle, startAngle - midpointAngle, true);
  } else {
    path.arcTo(Rect.fromCircle(center: centerOffset, radius: innerRadius),
        endAngle, startAngle - endAngle, true);
  }

  // Drawing two copies of this line segment, before and after the arcs,
  // ensures that the path actually gets closed correctly.
  path.lineTo(radiusStartPoint.x, radiusStartPoint.y);
  canvas.drawPath(path, paint);

  return path;
}

class DonutPainter extends CustomPainter {
  DonutPainter({
    @required this.data,
    @required this.sections,
    this.selectedStartValue,
    this.selectedEndValue,
    this.onSectionTapped,
    Listenable repaint,
  })  : assert(
          data != null,
          '`data` must not be null!',
        ),
        assert(
          sections != null,
          '`section` must not be null!',
        ),
        assert(
          selectedStartValue == null && selectedEndValue == null ||
              selectedStartValue != null && selectedEndValue != null,
          'If provided `selectedStartValue`, so '
          '`selectedEndValue` must be alse provided, '
          'and vice versa',
        ),
        super(repaint: repaint);

  final ChartData data;
  final List<Section> sections;
  final double selectedStartValue;
  final double selectedEndValue;
  final ValueChanged<int> onSectionTapped;

  final List<Path> paths = [];

  @deprecated
  Color getSectionColorAdaptive(int i) {
    final fractionCoef = 1 / sections.length;
    if (sections[i].selected) {
      return data.sectionColor;
    }

    final selectedIndex = sections.indexOfSelected;
    final index = i > selectedIndex
        ? i - selectedIndex
        : sections.length - 1 - selectedIndex + 1 + i;

    return data.sectionColor.withOpacity(1 - index * fractionCoef);
  }

  Color getSectionColor(int i) {
    final fractionCoef = 1 / sections.length;
    return data.sectionColor.withOpacity(1 - (i + 1) * fractionCoef);
  }

  void _paintBackgroundAndShadow({
    @required Canvas canvas,
    @required Point center,
    @required double radius,
    @required double innerRadius,
  }) {
    if (data.shadowColor != null) {
      // ! background
      final bgPath = _draw(
        canvas: canvas,
        center: center,
        radius: radius,
        innerRadius: innerRadius,
        startAngle: 0,
        endAngle: 2 * pi,
        fill: data.backgroundColor ?? const Color(0x00ffffff),
      );

      // ! shadow beneath the segment
      canvas.drawShadow(
        bgPath,
        data.shadowColor,
        data.shadowElevation,
        false,
      );
    }
  }

  void _paintSections({
    @required Size size,
    @required Canvas canvas,
    @required Point center,
    @required double radius,
    @required double innerRadius,
  }) {
    for (var i = 0; i < sections.length; i++) {
      final section = sections[i];

      final prevSum = sections.sumValuesBeforeIndex(i);
      final start = i == 0 ? .0 : prevSum * 2 * pi;
      final end =
          i == sections.length - 1 ? 2 * pi : section.value * 2 * pi + start;

      // ! segment
      paths.add(
        _draw(
          canvas: canvas,
          center: center,
          radius: radius,
          innerRadius: innerRadius,
          startAngle: start,
          endAngle: end,
          fill: section.color ?? getSectionColor(i),
        ),
      );

      // ! inner border
      if (data.hasInnerBorder() && data.innerStrokeWidth > 0) {
        final strokeShader = data.strokeGradient
            ?.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

        _draw(
          canvas: canvas,
          center: center,
          radius: innerRadius + data.innerStrokeWidth,
          innerRadius: innerRadius,
          startAngle: start,
          endAngle: end,
          fill: data.strokeColor,
          shader: strokeShader,
        );
      }

      // ! outer border
      if (data.hasOuterBorder() && data.outerStrokeWidth > 0) {
        final strokeShader = data.strokeGradient
            ?.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

        _draw(
          canvas: canvas,
          center: center,
          radius: radius,
          innerRadius: radius - data.outerStrokeWidth,
          startAngle: start,
          endAngle: end,
          fill: data.strokeColor,
          shader: strokeShader,
        );
      }
    }
  }

  void _paintSelectedSection({
    @required Size size,
    @required Canvas canvas,
    @required Point center,
    @required double radius,
    @required double innerRadius,
  }) {
    final start = selectedStartValue * 2 * pi;
    final end = selectedEndValue * 2 * pi;

    // ! segment
    _draw(
      canvas: canvas,
      center: center,
      radius: radius,
      innerRadius: innerRadius,
      startAngle: start,
      endAngle: end,
      fill: data.sectionColor,
    );

    // ! inner border
    if (data.hasInnerBorder() && data.innerStrokeWidth > 0) {
      final strokeShader = data.strokeSelectedGradient
          ?.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      _draw(
        canvas: canvas,
        center: center,
        radius: innerRadius + data.innerSelectedStrokeWidth,
        innerRadius: innerRadius,
        startAngle: start,
        endAngle: end,
        fill: data.strokeSelectedColor,
        shader: strokeShader,
      );
    }

    // ! outer border
    if (data.hasOuterBorder() && data.outerStrokeWidth > 0) {
      final strokeShader = data.strokeSelectedGradient
          ?.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      _draw(
        canvas: canvas,
        center: center,
        radius: radius,
        innerRadius: radius - data.outerSelectedStrokeWidth,
        startAngle: start,
        endAngle: end,
        fill: data.strokeSelectedColor,
        shader: strokeShader,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is DonutPainter) {
      if (data != oldDelegate.data) {
        return true;
      }
      if (sections.length != oldDelegate.sections.length) {
        return true;
      }
      for (var i = 0; i < sections.length; i++) {
        if (sections[i] != oldDelegate.sections[i]) {
          return true;
        }
      }

      return false;
    }

    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    paths.clear();

    final center = Point(size.width / 2, size.height / 2);
    final innerRadius = size.height / 3.3;
    final radius = size.height / 2.2;
    final selectedRadius = size.height / 2;

    _paintBackgroundAndShadow(
      canvas: canvas,
      center: center,
      radius: radius,
      innerRadius: innerRadius,
    );

    _paintSections(
      size: size,
      canvas: canvas,
      center: center,
      radius: radius,
      innerRadius: innerRadius,
    );

    _paintSelectedSection(
      size: size,
      canvas: canvas,
      center: center,
      radius: selectedRadius,
      innerRadius: innerRadius,
    );
  }

  @override
  bool hitTest(Offset position) {
    if (paths?.isNotEmpty != true) {
      return null;
    }

    for (var i = 0; i < sections.length; i++) {
      if (paths.length <= i) {
        return null;
      }

      final contains = paths[i].contains(position);

      if (contains) {
        onSectionTapped?.call(i);
      }
    }

    return null;
  }
}

class DonutLoadingPainter extends CustomPainter {
  DonutLoadingPainter({
    @required this.data,
    Listenable repaint,
  })  : assert(
          data != null,
          '`data` must not be null!',
        ),
        super(repaint: repaint);

  final ChartData data;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final center = Point(size.width / 2, size.height / 2);
    final innerRadius = size.height / 3.3;
    final radius = size.height / 2.2;

    // ! loader
    _draw(
      canvas: canvas,
      center: center,
      radius: radius,
      innerRadius: innerRadius,
      startAngle: 0,
      endAngle: 2 * pi,
      shader: SweepGradient(
        colors: [
          const Color(0x00ffffff),
          data.sectionColor,
        ],
      ).createShader(rect),
    );

    if (data.shadowColor != null) {
      // ! background
      final bgPath = _draw(
        canvas: canvas,
        center: center,
        radius: radius,
        innerRadius: innerRadius,
        startAngle: 0,
        endAngle: 2 * pi,
        fill: data.backgroundColor ?? const Color(0x00ffffff),
      );

      // ! shadow beneath the segment
      canvas.drawShadow(
        bgPath,
        data.shadowColor,
        data.shadowElevation,
        false,
      );
    }

    // ! inner border
    if (data.hasInnerBorder()) {
      if (data.innerStrokeWidth > 0) {
        final strokeColor = data.strokeColor;
        final strokeShader = data.strokeGradient?.createShader(rect);

        _draw(
          canvas: canvas,
          center: center,
          radius: innerRadius + data.innerStrokeWidth,
          innerRadius: innerRadius,
          startAngle: 0,
          endAngle: 2 * pi,
          fill: strokeColor,
          shader: strokeShader,
        );
      }
    }

    // ! outer border
    if (data.hasOuterBorder()) {
      if (data.outerStrokeWidth > 0) {
        final strokeColor = data.strokeColor;
        final strokeShader = data.strokeGradient?.createShader(rect);

        _draw(
          canvas: canvas,
          center: center,
          radius: radius,
          innerRadius: radius - data.outerStrokeWidth,
          startAngle: 0,
          endAngle: 2 * pi,
          fill: strokeColor,
          shader: strokeShader,
        );
      }
    }
  }
}
