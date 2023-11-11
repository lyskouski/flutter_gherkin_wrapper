// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a MIT license
// that can be found in the LICENSE file.

import 'package:flutter_gherkin_wrapper/flutter_gherkin_wrapper.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:gherkin/gherkin.dart';

class WhenTrigger extends Given {
  @override
  RegExp get pattern => RegExp(r"Trigger a frame");

  @override
  Future<void> executeStep() async {
    await FileRunner.tester.pump();
  }
}
