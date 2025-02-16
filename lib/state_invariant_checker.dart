import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Typedef for invariants, a simple predicate.
typedef StateInvariant = bool Function();

/// A widget that checks for state invariants in a Flutter application.
///
/// This widget is used to ensure that certain conditions or invariants
/// hold true within the state of the application. It extends
/// [StatelessWidget], meaning it does not have mutable state of its own.
///
/// For example:
///
/// ```dart
/// StateInvariantChecker(
///   invariants: {_valueShouldBeZeroOrPositive, _valueShouldBeLessThanTen},
///   child: // child...
/// )
///
/// bool _valueShouldBeZeroOrPositive() => !_value.isNegative;
///
/// bool _valueShouldBeLessThanTen() => _value < 10;
/// ```
final class StateInvariantChecker extends StatelessWidget {
  /// Creates an instance of [StateInvariantChecker].
  ///
  /// This constructor initializes the state invariant checker with the
  /// necessary parameters to perform its function.
  const StateInvariantChecker({
    required this.invariants,
    required this.child,
    super.key,
  });

  /// A set of state invariants that need to be checked.
  ///
  /// This set contains instances of [StateInvariant] which represent
  /// conditions or rules that the state must satisfy.
  final Set<StateInvariant> invariants;

  /// The child widget that this widget will display.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      for (final (i, invariant) in invariants.indexed) {
        assert(invariant(), 'Invariant at $i index was violated.');
      }
    }
    return child;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<StateInvariant>('invariants', invariants));
  }
}
