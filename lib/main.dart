import 'package:huuman/common_libs.dart';

void main() async {
  await initializeApplication();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appRouter = Get.find<RouterController>().router;
    return GetMaterialApp.router(
        routerDelegate: appRouter.delegate(),
        routeInformationParser: appRouter.defaultRouteParser(),
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: context.lightTheme);
  }
}
