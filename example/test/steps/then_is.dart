// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a MIT license
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:gherkin/gherkin.dart';

class ThenIs extends Given1<int> {
  @override
  RegExp get pattern => RegExp(r"Counter value is {int}");

  @override
  Future<void> executeStep(int expected) async {
    expect(find.text(expected.toString()), findsOneWidget);
  }
}
