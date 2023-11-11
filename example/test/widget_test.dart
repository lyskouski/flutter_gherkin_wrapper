// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
//
// RUN TESTS:
//   dart run build_runner build --delete-conflicting-outputs
//   flutter test

import 'dart:io';

import 'package:flutter_gherkin_generator/gen/generate_list_of_classes.dart';
import 'package:flutter_gherkin_wrapper/flutter_gherkin_wrapper.dart';
import 'package:flutter_test/flutter_test.dart';

@GenerateListOfClasses(['steps'])
import 'widget_test.list.dart';
// ! Pay attention to the file: ./steps/given_generic.dart

void main() {
  Iterable<File> features = Directory('./test/scenarios')
      .listSync(recursive: true)
      .where(
          (entity) => entity is File && entity.path.endsWith('.test.feature'))
      .cast<File>();

  setUpAll(() => ExecutableStepIterator.inject(classList));

  group('Behavioral Tests', () {
    for (var file in features) {
      testWidgets('Counter increments smoke test', (WidgetTester tester) async {
        final runner = FileRunner(tester);
        await runner.init(file);
        expectSync(await runner.run(), true);
      }, timeout: const Timeout(Duration(minutes: 1)));
    }
  });
}
