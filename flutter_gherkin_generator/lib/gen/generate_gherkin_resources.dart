// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a MIT license
// that can be found in the LICENSE file.

class GenerateGherkinResources {
  final List<String> folders;
  final String extension;
  const GenerateGherkinResources(
      [this.folders = const [], this.extension = '.resource.feature']);
}
