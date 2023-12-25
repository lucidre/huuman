import 'package:huuman/common_libs.dart';

extension Sizes on SizedBox {
  SizedBox operator *(num factor) {
    return SizedBox(height: (height ?? 0) * factor);
  }
}
