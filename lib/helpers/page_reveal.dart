import 'dart:math';
import 'dart:ui';

import 'package:huuman/common_libs.dart';

class PageReveal extends StatelessWidget {
  final double revealPercent;
  final Widget child;
  const PageReveal({Key? key, required this.revealPercent, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
        clipper: CircularRevealClipper(revealPercent: revealPercent),
        child: child);
  }
}

class AnimatedPageDragger {
  final bubbleWidth = 15.0;
  final fullTransitionPx = 300.0;
  final percentPerMillisecond = 0.00125;

  final TransitionGoal transitionGoal;
  final SlideUpdate slideUpdate;

  AnimationController? completionAnimationController;

  AnimatedPageDragger({
    required this.transitionGoal,
    required this.slideUpdate,
    required double slidePercent,
    required StreamController<SlideUpdate> slideUpdateStream,
    required TickerProvider vsync,
  }) {
    final startSlidePercent = slidePercent;
    double endSlidePercent;
    Duration duration;

    if (transitionGoal == TransitionGoal.open) {
      endSlidePercent = 1.0;
      final slideRemaining = 1.0 - slidePercent;

      duration = Duration(
          milliseconds: (slideRemaining / percentPerMillisecond).round());
    } else {
      endSlidePercent = 0.0;

      duration = Duration(
          milliseconds: (slidePercent / percentPerMillisecond).round());
    }

    completionAnimationController = AnimationController(
        duration: duration, vsync: vsync)
      ..addListener(() {
        final slidePercent = lerpDouble(startSlidePercent, endSlidePercent,
            completionAnimationController!.value);

        slideUpdateStream.add(SlideUpdate(
            slidePercent!, UpdateType.animating, slideUpdate.nextPage));
      })
      ..addStatusListener((AnimationStatus status) {
        //When animation has done executing
        if (status == AnimationStatus.completed) {
          //Adding to slide update stream
          slideUpdateStream.add(SlideUpdate(
              slidePercent, UpdateType.doneAnimating, slideUpdate.nextPage));
        }
      });
  }

  void run() {
    completionAnimationController?.forward(from: 0.0);
  }

  void dispose() {
    completionAnimationController?.dispose();
  }
}

enum UpdateType {
  dragging,
  doneDragging,
  animating,
  doneAnimating,
}

enum TransitionGoal {
  open,
  close,
}

// model for slide update

class SlideUpdate {
  final UpdateType updateType;
  final int nextPage;
  final double slidePercent;

  SlideUpdate(this.slidePercent, this.updateType, this.nextPage);
}

/// Custom clipper for circular page reveal.

class CircularRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;

  CircularRevealClipper({required this.revealPercent});

  @override
  Rect getClip(Size size) {
    // center of rectangle
    final center = Offset(size.width / 2, size.height * 0.9);

    // Calculate distance from center to the top left corner to make sure we fill the screen via simple trigonometry.
    double theta = atan(center.dy / center.dx);
    final distanceToCorner = center.dy / sin(theta);

    final radius = distanceToCorner * revealPercent;
    final diameter = 2 * radius;

    return Rect.fromLTWH(
        center.dx - radius, center.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
