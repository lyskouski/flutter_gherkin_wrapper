// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a MIT license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_gherkin_wrapper/flutter_gherkin_wrapper.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:gherkin/gherkin.dart';

class WhenTap extends Given1<String> {
  @override
  RegExp get pattern => RegExp(r"Tap the {string} icon");

  @override
  Future<void> executeStep(String icon) async {
    IconData search = switch (icon) {
      '+' => Icons.add,
      _ => Icons.question_mark,
    };
    await FileRunner.tester.tap(find.byIcon(search));
  }
}
