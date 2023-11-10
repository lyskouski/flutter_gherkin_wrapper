// Taken from: https://stackoverflow.com/questions/62551504/flutter-golden-image-tests-diff-threshold

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

import 'src/screen_comparator.dart';

// Golden tests will pass if the pixel difference is equal to or below 2.1%
const _kGoldenTestsThreshold = 2.1 / 100;

/// Override threshold for the golden image comparison
//  Include this file from /test/flutter_test_config.dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  if (goldenFileComparator is LocalFileComparator) {
    final testUrl = (goldenFileComparator as LocalFileComparator).basedir;

    goldenFileComparator = ScreenComparator(
      // flutter_test's LocalFileComparator expects the test's URI to be passed
      // as an argument, but it only uses it to parse the baseDir in order to
      // obtain the directory where the golden tests will be placed.
      // As such, we use the default `testUrl`, which is only the `baseDir` and
      // append a generically named `test.dart` so that the `baseDir` is
      // properly extracted.
      Uri.parse('$testUrl/main_test.dart'),
      _kGoldenTestsThreshold,
    );
  } else {
    throw Exception(
      'Expected `goldenFileComparator` to be of type `LocalFileComparator`, '
      'but it is of type `${goldenFileComparator.runtimeType}`',
    );
  }

  await testMain();
}
