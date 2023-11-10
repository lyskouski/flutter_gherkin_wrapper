// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a MIT license
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

import '../src/file_reader.dart';
import '../src/file_runner.dart';
import '../src/file_reporter.dart';

/// Use extend from Given generic with next notation:
//      @GenerateGherkinResources(['../../'])
//      Generic extends GivenGeneric {}
class GivenGeneric extends Given {
  @override
  RegExp get pattern => RegExp('%step%');

  @override
  // Execute sub-step
  Future<void> executeStep() async {
    final reporter = FileReporter();
    final step = await FileReader().getFromString('''%feature%''', reporter);
    final result = await FileRunner(FileRunner.tester, reporter).run(step);
    if (!result) {
      reporter.publish();
    }
    expectSync(result, true);
  }
}
