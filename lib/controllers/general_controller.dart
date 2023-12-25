import 'package:huuman/common_libs.dart';

class GeneralController extends GetxController {
  Timer? timer;

  final RxInt _onboardingChangeAnimationPos = 0.obs;

  int get onboardingChangeAnimationPos => _onboardingChangeAnimationPos.value;
  RxInt get onboardingChangeAnimationPosRx => _onboardingChangeAnimationPos;

  initTimer() => runTimer();
  stopTimer() => timer?.cancel();

  runTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      final text = onboardingChangeAnimationPos == 0
          ? 1
          : onboardingChangeAnimationPos == 1
              ? 2
              : 0;
      _onboardingChangeAnimationPos(text);
    });
  }
}
