import 'package:huuman/common_libs.dart';
import 'package:huuman/routing/app_router.dart';

class RouterController extends GetxController {
  final Rx<AppRouter> _router = AppRouter().obs;

  AppRouter get router => _router.value;
}
