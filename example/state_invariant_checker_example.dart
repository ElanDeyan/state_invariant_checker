import 'package:flutter/material.dart';
import 'package:state_invariant_checker/state_invariant_checker.dart';

void main(List<String> args) {
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
            spacing: 12,
            children: [
              const Text('This counter should not be negative...'),
              const Text('The checks are made only in debug mode'),
              const Text(
                'Try run this example in debug mode, and subtract the '
                'counter to be negative...',
              ),
              const Text('Counter value:'),
              Text(
                _value.toString(),
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: [
            FloatingActionButton(
              onPressed: _decrementValue,
              child: const Text('-', style: TextStyle(fontSize: 21)),
            ),
            FloatingActionButton(
              onPressed: _incrementValue,
              child: const Text('+', style: TextStyle(fontSize: 21)),
            ),
          ],
        ),
      ),
    );
  }

  bool _valueShouldBeZeroOrPositive() => !_value.isNegative;

  bool _valueShouldBeLessThanTen() => _value < 10;

  void _incrementValue() => setState(() {
    _value++;
  });

  void _decrementValue() => setState(() {
    _value--;
  });
}
