// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a MIT license
// that can be found in the LICENSE file.

import 'package:gherkin/gherkin.dart';

import 'executable_step_iterator.dart';

class WrapperConfiguration extends TestConfiguration {
  @override
  Iterable<Reporter>? get reporters => [
        StdoutReporter(MessageLevel.error),
        ProgressReporter(),
        TestRunSummaryReporter(),
        JsonReporter(path: './report.json'),
      ];

  @override
  Duration get defaultTimeout => const Duration(minutes: 5);

  @override
  Iterable<StepDefinitionGeneric<World>>? get stepDefinitions =>
      ExecutableStepIterator.classList;
}
