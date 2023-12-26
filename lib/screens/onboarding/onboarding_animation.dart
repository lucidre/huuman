import 'package:huuman/common_libs.dart';

class OnboardingAnimation extends StatefulWidget {
  const OnboardingAnimation({Key? key}) : super(key: key);

  @override
  State<OnboardingAnimation> createState() => _OnboardingAnimationState();
}

class _OnboardingAnimationState extends State<OnboardingAnimation>
    with TickerProviderStateMixin {
  late StreamController<SlideUpdate> slideUpdateStream;
  late AnimatedPageDragger animatedPageDragger;

  int activePageIndex = 0; //active page index
  int nextPageIndex = 0; //next page index

  double slidePercent = 0.0; //slide percentage (0.0 to 1.0)
  late StreamSubscription<SlideUpdate> slideUpdateStream$;

  void startAnimation(int index) async {
    slideUpdateStream.add(SlideUpdate(0.0, UpdateType.doneDragging, index));
  }

  @override
  void initState() {
    final controller = Get.find<GeneralController>();
    controller.onboardingChangeAnimationPosRx
        .listen((_) => startAnimation(controller.onboardingChangeAnimationPos));

    slideUpdateStream = StreamController<SlideUpdate>();

    slideUpdateStream$ = slideUpdateStream.stream.listen((SlideUpdate event) {
      setState(() {
        slidePercent = event.slidePercent;
        nextPageIndex = event.nextPage;

        //if the user has done dragging
        if (event.updateType == UpdateType.doneDragging) {
          //Auto completion of event using Animated page dragger.
          animatedPageDragger = AnimatedPageDragger(
              transitionGoal: TransitionGoal.open,
              slidePercent: slidePercent,
              slideUpdate: event,
              slideUpdateStream: slideUpdateStream,
              vsync: this);

          animatedPageDragger.run();
        }
        //when animating
        else if (event.updateType == UpdateType.animating) {
          slidePercent = event.slidePercent;
        }
        //done animating
        else if (event.updateType == UpdateType.doneAnimating) {
          activePageIndex = nextPageIndex;
          slidePercent = 0.0;
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    slideUpdateStream$.cancel();
    animatedPageDragger.dispose();
    slideUpdateStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = activePageIndex == 0
        ? huuman1
        : activePageIndex == 1
            ? huuman2
            : huuman3;

//transistions not working as expected, hence it is commented out for now.
    /*   final image2 = nextPageIndex == 0
        ? huuman2
        : nextPageIndex == 1
            ? huuman3
            : huuman1; */

    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 1 - slidePercent,
          child: Image.asset(image,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.contain),
        ),
        /*   PageReveal(
          revealPercent: slidePercent,
          child: Opacity(
            opacity: slidePercent,
            child: Image.asset(image2,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.contain),
          ),
        ), */
      ], //Widget
    );
  }
}
