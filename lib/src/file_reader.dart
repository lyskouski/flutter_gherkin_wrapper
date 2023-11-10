// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a MIT license
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
// ignore: implementation_imports
import 'package:gherkin/src/gherkin/parser.dart';
// ignore: implementation_imports
import 'package:gherkin/src/gherkin/runnables/feature_file.dart';

class FileReader {
  final language = LanguageService();

  FileReader() {
    language.initialise();
  }

  Future<FeatureFile> get(File file, [ProgressReporter? reporter]) async {
    return await getFromString(file.readAsStringSync(), reporter);
  }

  Future<FeatureFile> getFromString(String content,
      [ProgressReporter? reporter]) async {
    final parser = GherkinParser();
    final featureFile = FeatureFile(RunnableDebugInformation.EMPTY());
    final parserResult = await parser.parseFeatureFile(
      content,
      '',
      reporter ?? ProgressReporter(),
      language,
    );
    for (final feature in parserResult.features) {
      featureFile.addChild(feature);
    }
    return featureFile;
  }
}
