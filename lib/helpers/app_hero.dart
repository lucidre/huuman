import 'package:huuman/common_libs.dart';

/// Utility class that wraps a normal [Hero] widget, but respects WonderIllustrationConfig.enableHero setting
class AppHero extends StatelessWidget {
  const AppHero({
    Key? key,
    required this.tag,
    required this.child,
    this.enableHero = true,
  }) : super(key: key);

  final Widget child;
  final bool enableHero;
  final String tag;

  @override
  Widget build(BuildContext context) => enableHero
      ? Hero(
          createRectTween: (begin, end) => RectTween(begin: begin!, end: end!),
          tag: tag,
          child: child,
        )
      : child;
}
