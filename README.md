# State Invariant Checker

Based on Eiffel's language invariants and with a little help from ChatGPT, this package adds an extra tool to your development process. It allows you to run invariant checks before every build in debug mode, ensuring that your app's state remains consistent throughout its lifecycle.

## Features

- Invariant Enforcement: Check that specific conditions hold true for your app’s state at every build.
- Debug-Only Assertions: Invariant checks are performed only in debug mode, so there's no runtime overhead in production.
- Predictable Check Order: By using a list of invariants, you ensure a deterministic order for the checks, making debugging more straightforward.
- Flutter Integration: Built as a widget, it seamlessly integrates into your Flutter widget tree.

## Installation

Add the following dependency to your pubspec.yaml file:

```yaml
dependencies:
  state_invariant_checker: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

Wrap your app or a specific widget subtree with the StateInvariantChecker widget. Define your invariants as pure functions (without side effects) that return a bool indicating whether the invariant holds true.

Example:

```dart

import 'package:flutter/material.dart';
import 'package:state_invariant_checker/state_invariant_checker.dart';

void main() {
  runApp(const MaterialApp(home: MyCounterPage()));
}

class MyCounterPage extends StatefulWidget {
  const MyCounterPage({super.key});

  @override
  State<MyCounterPage> createState() => _MyCounterPageState();
}

class _MyCounterPageState extends State<MyCounterPage> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return StateInvariantChecker(
      invariants: [_valueShouldBeZeroOrPositive, _valueShouldBeLessThanTen],
      child: Scaffold(
        appBar: AppBar(title: const Text('Counter')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('This counter should not be negative...'),
              const Text('Invariant checks are made only in debug mode'),
              const Text('Try running this example in debug mode and subtract until the counter goes negative.'),
              const SizedBox(height: 20),
              Text(
                'Counter value: $_value',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: _decrementValue,
              child: const Text('-', style: TextStyle(fontSize: 21)),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              onPressed: _incrementValue,
              child: const Text('+', style: TextStyle(fontSize: 21)),
            ),
          ],
        ),
      ),
    );
  }

  bool _valueShouldBeZeroOrPositive() => _value >= 0;

  bool _valueShouldBeLessThanTen() => _value < 10;

  void _incrementValue() => setState(() {
    _value++;
  });

  void _decrementValue() => setState(() {
    _value--;
  });
}
```

In this example, every time the widget rebuilds (in debug mode), it checks that:

1. The counter is never negative.
2. The counter stays less than ten.

If any invariant is violated, an assertion error is thrown, indicating which invariant (by its index in the list) failed.

## API Reference

### StateInvariantChecker

A widget that takes a list of invariant functions and a child widget. It checks all invariants on each build in debug mode.

Constructor:

```dart
const StateInvariantChecker({
  required List<StateInvariant> invariants,
  required Widget child,
  Key? key,
})
```

### Properties

invariants: A list of pure functions (type StateInvariant) that each return a bool. These functions are expected to have no side effects.

child: The widget subtree to be displayed.

### Behavior

During the build process, if in debug mode, the widget iterates over the provided invariants and asserts each one.
The check leverages pattern matching to provide a helpful error message if an invariant is violated.
Contributing
Contributions are welcome! If you have suggestions or improvements, please open an issue or submit a pull request.

## Acknowledgements

ChatGPT: Special thanks to ChatGPT for the guidance on how to run functions before every build. Its assistance helped refine the implementation and documentation of this package.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
