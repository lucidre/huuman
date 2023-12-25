import 'dart:math';

import 'package:huuman/common_libs.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController controller2;
  late Animation<double> _animation;
  late Animation<double> _animation2;

  @override
  void initState() {
    controller = AnimationController(duration: fastDuration, vsync: this);
    controller2 = AnimationController(duration: fastDuration, vsync: this);

    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    _animation2 = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller2, curve: Curves.easeInOut));

    controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.router.push(const DescriptionRoute());

        Future.delayed(const Duration(seconds: 2), () {
          controller2.reverse();
        });
      }
    });

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
          buildCircularReveal2(),
        ],
      ),
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

  AnimatedBuilder buildCircularReveal2() {
    return AnimatedBuilder(
      animation: controller2,
      child: Container(
        color: greyColor3,
        width: context.screenWidth,
        height: context.screenHeight,
      ),
      builder: (context, child) {
        return Transform.scale(
          scale: 1 + _animation2.value,
          child: Opacity(
            opacity: _animation2.value,
            child: PageReveal(
                revealPercent: _animation2.value,
                child: child ?? const SizedBox()),
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
          children: [
            buildMenu(),
            verticalSpacer32,
            Expanded(child: buildHuuman()),
            buildItem1(),
            verticalSpacer24,
            buildItem2(),
          ],
        ),
      ),
    );
  }

  Container buildItem2() {
    return Container(
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
            ).fadeInAndMoveFromBottom(),
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
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onTap: () {
                      controller2.forward();
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
                            'See More',
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
                horizontalSpacer12,
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(space12),
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor, width: 2),
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(space16),
                  ),
                  child: Icon(Icons.message_outlined, color: primaryColor)
                      .fadeInAndMoveFromBottom(delay: fastDuration),
                ),
              ],
            ),
            //
          ],
        ));
  }

  Container buildItem1() {
    return Container(
        padding: const EdgeInsets.all(space24),
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor, width: 2),
          color: backgroundColor,
          borderRadius: BorderRadius.circular(space16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Animal care "Pawstar yo",\nHayam wurnk street No. 10',
                    style: poppins15w500.copyWith(fontWeight: FontWeight.bold),
                  ).fadeInAndMoveFromBottom(delay: fastDuration),
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
                ).fadeInAndMoveFromBottom(delay: fastDuration)
              ],
            ),
            verticalSpacer24,
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: primaryColor),
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
              ],
            ).fadeInAndMoveFromBottom(delay: fastDuration)
          ],
        ));
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
          child: Image.asset(huuman2, alignment: Alignment.bottomCenter),
        ),
      ).fadeIn(delay: fastDuration),
    );
  }

  Row buildMenu() {
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(space12),
          decoration: BoxDecoration(
            color: greyColor,
            border: Border.all(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(space16),
          ),
          child: Icon(Icons.menu_rounded, color: primaryColor)
              .fadeInAndMoveFromBottom(delay: fastDuration),
        ),
        horizontalSpacer16,
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(space12),
            decoration: BoxDecoration(
              color: greyColor,
              borderRadius: BorderRadius.circular(space16),
              border: Border.all(color: primaryColor, width: 2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(loremIspidiumTitle, style: poppins15w500),
                ),
                Icon(Icons.search_rounded, color: primaryColor),
              ],
            ),
          ).fadeInAndMoveFromBottom(delay: fastDuration),
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
}
