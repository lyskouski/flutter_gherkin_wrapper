// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a MIT license
// that can be found in the LICENSE file.

import 'package:gherkin/gherkin.dart';

class ExecutableStepIterator {
  /// Use next notation to inject steps (by scanning defined folders):
  //    @GenerateListOfClasses(['given', 'when', 'then'])
  //    import 'test_name.list.dart';
  /// In test:
  //    setUp() => ExecutableStepIterator.classList = classList;
  static List<StepDefinitionBase<World>> classList = [];

  // Basic parameters for the test execution
  final List<CustomParameter> param = <CustomParameter>[];

  // Evaluate test step
  ExecutableStepIterator() {
    param.addAll([
      NumParameterLower(),
      IntParameterLower(),
      StringParameterLower(),
      WordParameterLower(),
    ]);
  }

  // Registry step definitions
  List<ExecutableStep> _register(List<dynamic> steps) {
    return steps
        .map(
          (s) => ExecutableStep(GherkinExpression(s.pattern, param), s),
        )
        .toList();
  }

  // Aggregate all tests' steps
  Iterable<ExecutableStep> aggregate() {
    return _register(classList);
  }
}
