import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// A reusable custom loading spinner widget.
///
/// This widget displays a centered loading animation using the `loading_animation_widget` package.
///
/// Example usage:
/// ```dart
/// CustomLoadingSpinner(
///   color: Colors.blue,
///   size: 100,
/// )
/// ```
class CustomLoadingSpinner extends StatelessWidget {
  /// The color of the loading spinner.
  ///
  /// Defaults to `Color(0xffFFC009)` if not provided.
  final Color? color;

  /// The size of the loading spinner.
  ///
  /// Defaults to `50` if not provided.
  final double? size;

  /// Creates a [CustomLoadingSpinner] widget.
  ///
  /// The [color] and [size] parameters are optional.
  const CustomLoadingSpinner({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.discreteCircle(
        color: color ?? const Color(0xffFFC009),
        size: size ?? 50,
      ),
    );
  }
}
