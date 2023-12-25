import 'package:flutter/material.dart';

class AppSwipeConfiguration {
  //Vertical swipe configuration options
  final double verticalSwipeMaxWidthThreshold;
  final double verticalSwipeMinDisplacement;
  final double verticalSwipeMinVelocity;

  //Horizontal swipe configuration options
  final double horizontalSwipeMaxHeightThreshold;
  final double horizontalSwipeMinDisplacement;
  final double horizontalSwipeMinVelocity;

  const AppSwipeConfiguration({
    this.verticalSwipeMaxWidthThreshold = 50.0,
    this.verticalSwipeMinDisplacement = 100.0,
    this.verticalSwipeMinVelocity = 100.0,
    this.horizontalSwipeMaxHeightThreshold = 50.0,
    this.horizontalSwipeMinDisplacement = 100.0,
    this.horizontalSwipeMinVelocity = 300.0,
  });
}

class AppSwipeDetector extends StatelessWidget {
  final Widget child;
  final Function()? onSwipeUp;
  final Function()? onSwipeDown;
  final Function()? onSwipeLeft;
  final Function()? onSwipeRight;
  final AppSwipeConfiguration swipeConfiguration;

  const AppSwipeDetector({
    Key? key,
    required this.child,
    this.onSwipeUp,
    this.onSwipeDown,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.swipeConfiguration = const AppSwipeConfiguration(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Vertical drag details
    DragStartDetails? startVerticalDragDetails;
    DragUpdateDetails? updateVerticalDragDetails;

    //Horizontal drag details
    DragStartDetails? startHorizontalDragDetails;
    DragUpdateDetails? updateHorizontalDragDetails;

    return GestureDetector(
      child: child,
      onVerticalDragStart: (dragDetails) {
        startVerticalDragDetails = dragDetails;
      },
      onVerticalDragUpdate: (dragDetails) {
        updateVerticalDragDetails = dragDetails;
      },
      onVerticalDragEnd: (endDetails) {
        if (updateVerticalDragDetails == null ||
            startVerticalDragDetails == null ||
            endDetails.primaryVelocity == null) {
          return;
        }
        double dx = updateVerticalDragDetails!.globalPosition.dx -
            startVerticalDragDetails!.globalPosition.dx;
        double dy = updateVerticalDragDetails!.globalPosition.dy -
            startVerticalDragDetails!.globalPosition.dy;

        double velocity = endDetails.primaryVelocity!;

        //Convert values to be positive
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        double positiveVelocity = velocity < 0 ? -velocity : velocity;

        if (dx > swipeConfiguration.verticalSwipeMaxWidthThreshold) {
          return;
        }
        if (dy < swipeConfiguration.verticalSwipeMinDisplacement) {
          return;
        }
        if (positiveVelocity < swipeConfiguration.verticalSwipeMinVelocity) {
          return;
        }

        if (velocity < 0) {
          //Swipe Up
          if (onSwipeUp != null) {
            onSwipeUp!();
          }
        } else {
          //Swipe Down
          if (onSwipeDown != null) {
            onSwipeDown!();
          }
        }
      },
      onHorizontalDragStart: (dragDetails) {
        startHorizontalDragDetails = dragDetails;
      },
      onHorizontalDragUpdate: (dragDetails) {
        updateHorizontalDragDetails = dragDetails;
      },
      onHorizontalDragEnd: (endDetails) {
        if (updateHorizontalDragDetails == null ||
            startHorizontalDragDetails == null ||
            endDetails.primaryVelocity == null) {
          return;
        }
        double dx = updateHorizontalDragDetails!.globalPosition.dx -
            startHorizontalDragDetails!.globalPosition.dx;
        double dy = updateHorizontalDragDetails!.globalPosition.dy -
            startHorizontalDragDetails!.globalPosition.dy;
        double velocity = endDetails.primaryVelocity!;

        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        double positiveVelocity = velocity < 0 ? -velocity : velocity;

        if (dx < swipeConfiguration.horizontalSwipeMinDisplacement) {
          return;
        }
        if (dy > swipeConfiguration.horizontalSwipeMaxHeightThreshold) {
          return;
        }
        if (positiveVelocity < swipeConfiguration.horizontalSwipeMinVelocity) {
          return;
        }

        if (velocity < 0) {
          //Swipe Up
          if (onSwipeLeft != null) {
            onSwipeLeft!();
          }
        } else {
          //Swipe Down
          if (onSwipeRight != null) {
            onSwipeRight!();
          }
        }
      },
    );
  }
}
