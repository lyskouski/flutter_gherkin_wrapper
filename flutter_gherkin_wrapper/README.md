# Flutter Gherkin Wrapper

[![Test Status](https://github.com/lyskouski/flutter_gherkin_wrapper/actions/workflows/test.yml/badge.svg)](https://github.com/lyskouski/dart_class_wrapper/actions/workflows/test.yml)
[![Build Status](https://github.com/lyskouski/flutter_gherkin_wrapper/actions/workflows/build.yml/badge.svg)](https://github.com/lyskouski/dart_class_wrapper/actions/workflows/build.yml)
<a href="https://www.buymeacoffee.com/lyskouski"><img height="20" src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=lyskouski&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff" /></a>

Wrapper is used to execute widget (component) tests with Cucumber / Gherkin 
notation instead of integration tests as done for original 
`flutter_gherkin`-package.

Has to be used together with `flutter_gherkin_generator`-package.

## Getting started

### Initialization
```dart
// Generate steps from resources
// ./test/e2e/given/generic.dart
@GenerateGherkinResources(['../steps'])
class Generic extends GivenGeneric {}

// Generate list of steps
// ./test/e2e/steps_iterator.dart
@GenerateListOfClasses(['given', 'when', 'then'])
import 'steps_iterator.list.dart';

ExecutableStepIterator.inject(classList);
```
```gherkin
# /test/e2e/steps/open_expense_form.resource.feature
Feature: Verify Basic Actions

  Scenario: Opened Expense Form
    Given I am on "Home" page
     When I tap "Add Bill, Income or Transfer" button
     Then I can see "Add new Bill" button
```

### Execution
```dart
void main() {
  Iterable<File> features = Directory('./test/e2e')
      .listSync(recursive: true)
      .where(
          (entity) => entity is File && entity.path.endsWith('.test.feature'))
      .cast<File>();

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    ScreenCapture.enableScreenCapture();
    // MainTest.cleanUpData();
  });

  group('Run All End-To-End Tests', () {
    for (var file in features) {
      testWidgets(file.path, (WidgetTester tester) async {
        // await MainTest.init(tester);
        final runner = FileRunner(tester);
        await runner.init(file);
        // ! to avoid collisions in concurrent requests
        expectSync(await runner.run(), true);
        await tester.pumpAndSettle();
      }, timeout: const Timeout(Duration(minutes: 5)));
    }
  });
}
```
```gherkin
# /test/e2e/bill/create_different_expenses.test.feature
Feature: Verify Expenses Functionality

  Scenario Outline: Added different Expenses
    Given Opened Expense Form
     When I select "<account>" from "AccountSelector" with "Enter Account Identifier" tooltip
      And ...
```

In addition to thanking, you may [treat us to :coffee:](https://www.buymeacoffee.com/lyskouski).
