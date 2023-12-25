import 'dart:math';

import 'package:huuman/common_libs.dart';

@RoutePage()
class DescriptionScreen extends StatefulWidget {
  const DescriptionScreen({super.key});

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> _animation;

  @override
  void initState() {
    controller = AnimationController(duration: fastDuration, vsync: this);

    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    Future.delayed(Duration.zero, () {
      controller.forward();
    });

    super.initState();
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

  AnimatedBuilder buildCircularReveal() {
    return AnimatedBuilder(
      animation: controller,
      child: Container(
        color: greyColor3,
        width: context.screenWidth,
        height: context.screenHeight,
      ),
      builder: (context, child) {
        return Transform.scale(
          scale: 2 - _animation.value,
          child: Opacity(
            opacity: 1 - _animation.value,
            child: Transform.rotate(
              angle: pi,
              child: PageReveal(
                  revealPercent: 1 - _animation.value,
                  child: child ?? const SizedBox()),
            ),
          ),
        );
      },
    );
  }

  SafeArea buildBody() {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildText1().fadeInAndMoveFromBottom(delay: fastDuration),
          verticalSpacer24,
          buildText2().fadeInAndMoveFromBottom(delay: fastDuration),
          verticalSpacer24,
          Expanded(child: buildHuuman()),
          Container(
              padding: const EdgeInsets.all(space16),
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor, width: 2),
                color: backgroundColor,
                borderRadius: BorderRadius.circular(space16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Facilities',
                    style: poppins15w500.copyWith(fontWeight: FontWeight.bold),
                  ).fadeInAndMoveFromBottom(delay: fastDuration),
                  verticalSpacer16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildFacilitiesItem(bath, 'Bath'),
                      buildFacilitiesItem(stay, 'Stay'),
                      buildFacilitiesItem(spa, 'Spa'),
                      buildFacilitiesItem(practice, 'Practice'),
                      buildFacilitiesItem(care, 'Care'),
                    ],
                  ),
                  verticalSpacer16,
                  Text(
                    'Resavation',
                    style: poppins15w500.copyWith(fontWeight: FontWeight.bold),
                  ).fadeInAndMoveFromBottom(delay: fastDuration),
                  verticalSpacer16,
                  buildTimeline().fadeInAndMoveFromBottom(delay: fastDuration),
                  verticalSpacer16,
                  Container(
                    padding: const EdgeInsets.all(space16),
                    decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.circular(space16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Cost:', style: poppins16Bold),
                        ),
                        Text('150\$ USD', style: poppins16Bold),
                      ],
                    ),
                  ),
                  verticalSpacer16,
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onTap: () {
                            context.router.push(const DescriptionRoute());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(space12),
                            decoration: BoxDecoration(
                              border: Border.all(color: primaryColor, width: 2),
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(space16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Book Now',
                                  style: poppins15w500.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                horizontalSpacer8,
                                Icon(Icons.chevron_right_rounded,
                                    color: primaryColor),
                              ],
                            ).fadeInAndMoveFromBottom(delay: fastDuration),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //
                ],
              )),

          //
        ],
      ),
    ));
  }

  Row buildTimeline() {
    return Row(
      children: [
        Text('From', style: poppins15w500.copyWith(color: primaryColor)),
        horizontalSpacer8,
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(space12),
            decoration: BoxDecoration(
              color: greyColor,
              borderRadius: BorderRadius.circular(space16),
            ),
            child: FittedBox(
              child: Row(
                children: [
                  Icon(Icons.calendar_month_rounded, color: primaryColor),
                  horizontalSpacer8,
                  Text(
                    '20/08/2020',
                    style: poppins15w500.copyWith(color: primaryColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        horizontalSpacer16,
        Text('To', style: poppins15w500.copyWith(color: primaryColor)),
        horizontalSpacer8,
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(space12),
            decoration: BoxDecoration(
              color: greyColor,
              borderRadius: BorderRadius.circular(space16),
            ),
            child: FittedBox(
              child: Row(
                children: [
                  Icon(Icons.calendar_month_rounded, color: primaryColor),
                  horizontalSpacer8,
                  Text(
                    '22/08/2020',
                    style: poppins15w500.copyWith(color: primaryColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFacilitiesItem(String icon, String text) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Image.asset(
            icon,
            height: double.infinity,
            width: double.infinity,
          ),
        ).fadeInAndMoveFromBottom(delay: fastDuration),
        Text(text, style: poppins13Bold)
            .fadeInAndMoveFromBottom(delay: fastDuration),
      ],
    );
  }

  Transform buildHuuman() {
    return Transform.translate(
      offset: const Offset(0, 10),
      child: Container(
        padding: const EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
        ),
        child: AppHero(
          tag: "huuman",
          child: Image.asset(
            huuman1,
            alignment: Alignment.bottomCenter,
          ),
        ),
      ).fadeIn(delay: fastDuration),
    );
  }

  Row buildText2() {
    return Row(
      children: [
        const Spacer(),
        Container(
          width: 20,
          height: 20,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: primaryColor),
        ),
        horizontalSpacer4,
        Text('+1Q5', style: poppins13Bold),
        const Spacer(),
        Icon(Icons.star_rounded, color: primaryColor),
        horizontalSpacer4,
        Text('5.0 ratings', style: poppins13Bold),
        const Spacer(),
        Icon(Icons.pin_drop_rounded, color: primaryColor),
        horizontalSpacer4,
        Text('Surabaya, IDN', style: poppins13Bold),
        const Spacer(),
      ],
    );
  }

  Row buildText1() {
    return Row(
      children: [
        buildMenu(),
        horizontalSpacer12,
        Expanded(
          child: Text(
            'Animal care "Pawstar yo",\nHayam wurnk street No. 10',
            style: poppins15w500.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        horizontalSpacer12,
        Container(
          padding: const EdgeInsets.all(space6),
          decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(.2),
                  spreadRadius: 4,
                  blurRadius: 8,
                  offset: const Offset(1, 1),
                ),
              ]),
          child: Icon(Icons.favorite_rounded, color: backgroundColor),
        )
      ],
    );
  }

  InkWell buildMenu() {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
        context.router.pop();
      },
      child: Container(
        padding: const EdgeInsets.all(space12),
        decoration: BoxDecoration(
          color: greyColor,
          border: Border.all(color: primaryColor, width: 2),
          borderRadius: BorderRadius.circular(space16),
        ),
        child: Icon(
          Icons.keyboard_arrow_left_rounded,
          color: primaryColor,
        ).fadeInAndMoveFromBottom(delay: fastDuration),
      ),
    );
  }
}
