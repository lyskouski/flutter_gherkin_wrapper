// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a MIT license
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'generate_gherkin_resources.dart';

Builder gherkinGenericGenerator(BuilderOptions options) => LibraryBuilder(
      GherkinGenericGenerator(),
      generatedExtension: '.generic.dart',
    );

class GherkinGenericGenerator extends Generator {
  Future<String> build(Element node, Iterable<DartObject> annotations) async {
    final scope = StringBuffer();
    for (final annotation in annotations) {
      final note = annotation.getField('folders');
      final extension = annotation.getField('extension');
      final parts =
          node.source?.uri.toString().split(RegExp(r'[\\/]', unicode: true));
      final dir = parts?.sublist(1, parts.length - 1).join('/');
      if (note == null ||
          note.isNull ||
          dir == null ||
          dir.isEmpty ||
          extension == null ||
          extension.isNull) {
        continue;
      }
      final templateFile = await File('$dir/${parts?.last}').readAsString();
      final regClass = RegExp(r'class\s+(\w+)');
      final chunks = templateFile.split(regClass);
      scope.writeln(chunks[0]);
      final template = chunks[1];
      for (final name in note.toListValue()!) {
        Iterable<File> files = Directory('$dir/${name.toStringValue()}')
            .listSync(recursive: true)
            .where((entity) =>
                entity is File &&
                entity.path.endsWith(extension.toStringValue()!))
            .cast<File>();
        for (final file in files) {
          String content = await file.readAsString();
          final pattern = RegExp(r"(Scenario(?: Outline)?:)");
          final matches = pattern.allMatches(content);
          final scenarioNames = matches.map((m) => m.group(0)).toList();
          final scenarios = content.split(pattern).toList();
          scenarioNames.asMap().forEach((index, scenario) {
            final name =
                scenarios[index + 1].split(RegExp('(\n|\r)')).first.trim();
            scope.writeln('class ${name.replaceAll(' ', '')}$template'
                .replaceAll('%step%', name)
                .replaceAll(
                    '%feature%',
                    '${scenarios[0]}\n$scenario${scenarios[index + 1]}'
                        .replaceAll('\$', '\\\$')));
          });
        }
      }
    }
    return scope.toString();
  }

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    final result = StringBuffer();
    for (final element in library.allElements) {
      final annotations =
          const TypeChecker.fromRuntime(GenerateGherkinResources)
              .annotationsOf(element);
      if (annotations.isNotEmpty) {
        result.writeln(await build(element, annotations));
      }
    }
    return result.toString();
  }
}
