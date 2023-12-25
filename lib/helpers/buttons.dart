import 'package:gap/gap.dart';
import 'package:huuman/common_libs.dart';

/// Shared methods across button types
Widget _buildIcon(BuildContext context, IconData icon,
        {required bool isOutlined,
        required bool isSecondary,
        required double? size}) =>
    Icon(icon,
        color: (isOutlined) ? Colors.black : Colors.white, size: size ?? 18);

/// The core button that drives all other buttons.
class AppBtn extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  AppBtn({
    Key? key,
    required this.onPressed,
    required this.semanticLabel,
    this.enableFeedback = true,
    this.isOutlined = false,
    this.isElevated = false,
    this.isLoading = false,
    this.pressEffect = true,
    this.child,
    this.padding,
    this.expand = false,
    required this.isSecondary,
    this.circular = false,
    this.minimumSize,
    this.bgColor,
    this.borderColor,
    this.textColor,
    this.border,
  })  : _builder = null,
        super(key: key);

  /// useful for elevated buttons or outlined buttons
  AppBtn.from({
    Key? key,
    required this.onPressed,
    this.enableFeedback = true,
    this.pressEffect = true,
    this.padding = const EdgeInsets.only(
        top: kDefaultPadding,
        bottom: kDefaultPadding,
        right: kDefaultPadding * 2,
        left: kDefaultPadding * 2),
    this.expand = true,
    this.isOutlined = false,
    required this.isSecondary,
    this.minimumSize,
    this.bgColor,
    this.borderColor,
    this.textColor,
    this.border,
    this.isElevated = false,
    this.isLoading = false,
    String? semanticLabel,
    required String? text,
    IconData? icon,
    double? iconSize,
  })  : child = null,
        circular = false,
        super(key: key) {
    if (semanticLabel == null && text == null) {
      throw ('AppBtn.from must include either text or semanticLabel');
    }
    this.semanticLabel = semanticLabel ?? text ?? '';
    _builder = (context) {
      if (text == null && icon == null) return const SizedBox.shrink();
      Text? txt = text == null
          ? null
          : Text(text,
              style: poppins18w500.copyWith(
                  fontWeight: FontWeight.bold,
                  color:
                      textColor ?? (isOutlined ? Colors.black : Colors.white)),
              textHeightBehavior:
                  const TextHeightBehavior(applyHeightToFirstAscent: false));
      Widget? icn = icon == null
          ? null
          : _buildIcon(
              context,
              icon,
              isSecondary: isSecondary,
              size: iconSize,
              isOutlined: isOutlined,
            );
      if (isLoading) {
        return const SizedBox(
          height: 20,
          width: 20,
          child:
              CircularProgressIndicator.adaptive(backgroundColor: Colors.black),
        );
      } else if (txt != null && icn != null) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [txt, const Gap(kDefaultMargin), icn],
        );
      } else {
        return (txt ?? icn)!;
      }
    };
  }

  /// useful for textbuttons or custom buttons where you specify the child
  // ignore: prefer_const_constructors_in_immutables
  AppBtn.basic({
    Key? key,
    required this.onPressed,
    this.isElevated = false,
    this.semanticLabel = '',
    this.enableFeedback = true,
    this.isOutlined = false,
    this.pressEffect = true,
    this.padding = EdgeInsets.zero,
    required this.isSecondary,
    this.circular = false,
    this.minimumSize,
    required this.child,
  })  : expand = false,
        bgColor = Colors.transparent,
        borderColor = Colors.black,
        textColor = Colors.black,
        border = null,
        isLoading = false,
        _builder = null,
        super(key: key);

  // interaction:
  final VoidCallback onPressed;
  late final String semanticLabel;
  final bool enableFeedback;

  // content:
  late final Widget? child;
  late final WidgetBuilder? _builder;

  // layout:
  final EdgeInsets? padding;
  final bool expand;
  final bool circular;
  final Size? minimumSize;
  final bool isElevated;

  // style:
  final bool isSecondary;

  final bool isOutlined;
  final bool isLoading;
  final BorderSide? border;
  final Color? bgColor;
  final Color? borderColor;
  final Color? textColor;
  final bool pressEffect;

  @override
  Widget build(BuildContext context) {
    Color defaultColor = borderColor ?? Colors.black;
    Color textColor =
        (isOutlined ? !isSecondary : isSecondary) ? Colors.black : Colors.white;
    BorderSide side = border ??
        (isOutlined
            ? BorderSide(width: 1.0, color: defaultColor)
            : BorderSide.none);

    Widget content =
        _builder?.call(context) ?? child ?? const SizedBox.shrink();
    if (expand) content = Center(child: content);

    OutlinedBorder shape = circular
        ? CircleBorder(side: side)
        : RoundedRectangleBorder(
            side: side,
            borderRadius: BorderRadius.circular(30),
          );

    ButtonStyle style = ButtonStyle(
      elevation: ButtonStyleButton.allOrNull<double>(isOutlined
          ? 0.0
          : isElevated
              ? 4.0
              : 0.0),
      minimumSize: ButtonStyleButton.allOrNull<Size>(minimumSize ?? Size.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      splashFactory: NoSplash.splashFactory,
      backgroundColor: ButtonStyleButton.allOrNull<Color>(
          bgColor ?? (isOutlined ? Colors.black : Colors.white)),
      overlayColor: ButtonStyleButton.allOrNull<Color>(
          Colors.transparent), // disable default press effect
      shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
      padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(
          padding ?? const EdgeInsets.all(kDefaultPadding / 4)),
      enableFeedback: enableFeedback,
    );

    Widget button = TextButton(
      onPressed: () => onPressed(),
      style: style,
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.copyWith(color: textColor),
        child: content,
      ),
    );

    // add press effect:
    if (pressEffect) button = _ButtonPressEffect(button);

    // add semantics?
    if (semanticLabel.isEmpty) return button;
    return Semantics(
      label: semanticLabel,
      button: true,
      container: true,
      child: ExcludeSemantics(child: button.fadeIn()),
    );
  }
}

/// //////////////////////////////////////////////////
/// _ButtonDecorator
/// Add a transparency-based press effect to buttons.
/// //////////////////////////////////////////////////
class _ButtonPressEffect extends StatefulWidget {
  const _ButtonPressEffect(this.child, {Key? key}) : super(key: key);
  final Widget child;

  @override
  State<_ButtonPressEffect> createState() => _ButtonPressEffectState();
}

class _ButtonPressEffectState extends State<_ButtonPressEffect> {
  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      excludeFromSemantics: true,
      onTapDown: (_) => setState(() => _isDown = true),
      onTapUp: (_) => setState(
          () => _isDown = false), // not called, TextButton swallows this.
      onTapCancel: () => setState(() => _isDown = false),
      behavior: HitTestBehavior.translucent,
      child: Opacity(
        opacity: _isDown ? 0.7 : 1,
        child: ExcludeSemantics(child: widget.child),
      ),
    );
  }
}
