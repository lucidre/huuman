import 'package:flutter_animate/flutter_animate.dart';
import 'package:huuman/common_libs.dart';

extension WidgetAnimation on Widget {
  fadeInAndMoveFromTop({
    Duration? delay,
    Duration? animationDuration,
    Offset? offset,
  }) =>
      animate(delay: delay ?? fastDuration)
          .move(
              duration: animationDuration ?? fastDuration,
              begin: offset ?? const Offset(0, -10))
          .fade(duration: animationDuration ?? fastDuration);

  fadeInAndMoveFromBottom({
    Duration? delay,
    Duration? animationDuration,
    Offset? offset,
  }) =>
      animate(delay: delay ?? fastDuration)
          .move(
              duration: animationDuration ?? fastDuration,
              begin: offset ?? const Offset(0, 10))
          .fade(duration: animationDuration ?? fastDuration);

  fadeIn({
    Duration? delay,
    Duration? animationDuration,
    Curve? curve,
  }) =>
      animate(delay: delay ?? fastDuration).fade(
          duration: animationDuration ?? fastDuration,
          curve: curve ?? Curves.decelerate);
}
