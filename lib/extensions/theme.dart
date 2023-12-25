import 'package:huuman/common_libs.dart';

extension DeviceTheme on BuildContext {
  ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: primaryColor),
        canvasColor: backgroundColor,
        dialogBackgroundColor: backgroundColor,
        floatingActionButtonTheme: ThemeData.light()
            .floatingActionButtonTheme
            .copyWith(backgroundColor: primaryColor),
        cardColor: backgroundColor,
        iconTheme:
            ThemeData.light().iconTheme.copyWith(color: primaryColor, size: 24),
      );
}

Color get primaryColor => const Color(0xFF1D1E20);
Color get greyColor => const Color(0xFFE9E9E9);
Color get greyColor2 => const Color(0xFFB9BBC1);
Color get greyColor3 => const Color(0xFF707172);
Color get backgroundColor => const Color(0xFFFFFFFF);
