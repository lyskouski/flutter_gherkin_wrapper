// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a MIT license
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:gherkin/gherkin.dart';

class FileReporter extends ProgressReporter {
  static const eoc = StdoutReporter.RESET_COLOR;
  final _log = StringBuffer();
  Function(String text) get _writeln => _log.writeln;
  Function(String text) get _write => _log.write;

  @override
  void printMessageLine(
    String message, [
    String? colour,
  ]) {
    if (supportsAnsiEscapes) {
      _writeln('${colour ?? eoc}$message$eoc');
    } else {
      _writeln(message);
    }
  }

  @override
  void printMessage(
    String message, [
    String? colour,
  ]) {
    if (supportsAnsiEscapes) {
      _write('${colour ?? eoc}$message$eoc');
    } else {
      _writeln(message);
    }
  }

  void publish() {
    stdout.writeln(_log.toString());
  }
}
