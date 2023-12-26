import 'package:focus_detector/focus_detector.dart';
import 'package:huuman/common_libs.dart';
import 'package:huuman/screens/onboarding/onboarding_animation.dart';

@RoutePage()
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(duration: fastDuration, vsync: this);

    animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.router.push(const HomeRoute());

        //reverse the animation after the page change.
        Future.delayed(const Duration(seconds: 2), () => controller.reverse());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          buildDecore(),
          buildBody(),
          buildCircularReveal(),
        ],
      ),
    );
  }

  buildBody() {
    return FocusDetector(
      onFocusGained: () => Get.find<GeneralController>().initTimer(),
      onFocusLost: () => Get.find<GeneralController>().stopTimer(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              top: kDefaultPadding,
              left: kDefaultPadding,
              right: kDefaultPadding,
              bottom: kDefaultPadding * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTexts(),
              Expanded(
                  child: const Center(
                child: AppHero(
                  tag: "huuman",
                  child: OnboardingAnimation(),
                ),
              ).fadeInAndMoveFromBottom()),
              verticalSpacer24,
              buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  Align buildButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: () => controller.forward(),
        child: Container(
          height: 50,
          width: 200,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cornersLarge),
            color: primaryColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Get started',
                style: poppins15w500.copyWith(
                    color: backgroundColor, fontWeight: FontWeight.w500),
              ),
              horizontalSpacer8,
              Icon(Icons.chevron_right_rounded, color: backgroundColor),
            ],
          ),
        ).fadeInAndMoveFromBottom(),
      ),
    );
  }

  Padding buildTexts() {
    return Padding(
      padding: const EdgeInsets.all(space16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Welcome to', style: poppins18w500.copyWith(height: 1))
            .fadeInAndMoveFromBottom(),
        verticalSpacer8,
        SizedBox(
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text('Pawstar', style: poppins30Bold.copyWith(height: 1)),
          ),
        ).fadeInAndMoveFromBottom(),
        verticalSpacer8,
        Align(
                alignment: Alignment.centerRight,
                child: Text('animal care',
                    style: poppins18w500.copyWith(height: 1)))
            .fadeInAndMoveFromBottom(),
      ]),
    );
  }

  AnimatedBuilder buildCircularReveal() {
    return AnimatedBuilder(
      animation: controller,
      child: Container(
        color: primaryColor,
        width: context.screenWidth,
        height: context.screenHeight,
      ),
      builder: (context, child) {
        return Transform.scale(
          scale: 1 + animation.value,
          child: Opacity(
            opacity: animation.value,
            child: PageReveal(
                revealPercent: animation.value,
                child: child ?? const SizedBox()),
          ),
        );
      },
    );
  }

  Positioned buildDecore() {
    return Positioned(
      top: -30,
      right: -30,
      child: AppHero(
        tag: 'decore',
        child: Image.asset(decore, height: 500, width: 500),
      ).fadeIn(),
    );
  }
}
