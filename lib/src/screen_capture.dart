// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a MIT license
// that can be found in the LICENSE file.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScreenCapture {
  // Record images
  static String output = '${Directory.current.absolute.path}/coverage/images';
  // Unification key
  static final GlobalKey _id = GlobalKey();
  // Step iterator
  static int _step = 0;
  // Declaration if images is needed to be saved
  static bool _saveScreen = false;

  // Get unique key
  static GlobalKey getKey() => _id;

  // Activate screen recorder
  static void enableScreenCapture([bool cleanup = true]) {
    _saveScreen = true;
    if (cleanup) {
      dropImages();
    }
  }

  // Make a screenshot
  static Future<void> seize(String name) async {
    if (!_saveScreen || _id.currentContext == null) {
      return;
    }
    int currentStep = _step++;
    // debugDumpApp();
    final boundary =
        _id.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List imageData = bytes!.buffer.asUint8List();
    File file =
        File('$output/${currentStep.toString().padLeft(8, '0')}_$name.png');
    file.createSync(recursive: true, exclusive: false);
    file.writeAsBytesSync(imageData);
  }

  // Delete all images from targeted folder
  static Future<void> dropImages() async {
    final dir = Directory(output);
    if (!dir.existsSync()) {
      return;
    }
    dir.deleteSync(recursive: true);
  }
}
