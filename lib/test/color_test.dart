import 'package:android_studio_projects/providers/theme_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Changing the background color between black and white:", () {

    final theme = ThemeProvider();
    print("Default color: " + theme.myTitleColor.toString());
    final default_color = theme.myTitleColor;
    theme.toggleTTL();
    print("After calling toggleBGC function: " + theme.myTitleColor.toString());
    theme.toggleTTL();
    print("After calling it again, the color is: " + theme.myTitleColor.toString());
    expect(default_color, theme.myTitleColor);
  });
}
