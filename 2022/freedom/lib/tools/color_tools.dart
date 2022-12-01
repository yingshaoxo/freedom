import 'dart:math';
import 'dart:ui';

class ColorTools {
  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static Color getRandomColor() {
    return Color(0xFF000000 + Random().nextInt(0xFFFFFF));
  }

  static List<Color> getAListOfRandomColors(int length, {double opacity = 1}) {
    List<Color> colors = [];
    for (int i = 0; i < length; i++) {
      colors.add(getRandomColor().withOpacity(opacity));
    }
    return colors;
  }
}
