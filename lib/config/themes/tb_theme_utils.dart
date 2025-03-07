import 'package:flutter/material.dart';
import 'package:thingsboard_app/thingsboard_client.dart';
import 'package:thingsboard_app/utils/transition/page_transitions.dart';

abstract class TbThemeUtils {
  static final _tbTypography = Typography.material2018();

  static const Color _tbTextColor = Color(0xFF282828);

  // Updated primary and secondary colors based on CIO's request
  static final tbPrimary = _createMaterialColor(const Color(0xFFE02129)); // Primary Color
  static final tbAccent = _createMaterialColor(const Color(0xFFE53935)); // Secondary Color

  static ThemeData createTheme(PaletteSettings? paletteSettings) {
    var primarySwatch =
        _materialColorFromPalette(paletteSettings?.primaryPalette, true) ??
            tbPrimary;
    var accentColor =
        _materialColorFromPalette(paletteSettings?.accentPalette, false) ??
            tbAccent;
    var primaryColor = primarySwatch[500]!;
    ThemeData theme = ThemeData(primarySwatch: primarySwatch);
    return ThemeData(
      useMaterial3: false,
      primarySwatch: primarySwatch,
      colorScheme: theme.colorScheme.copyWith(primary: primaryColor, secondary: accentColor),
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      textTheme: _tbTypography.black,
      primaryTextTheme: _tbTypography.black,
      typography: _tbTypography,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: _tbTextColor,
        iconTheme: IconThemeData(color: _tbTextColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.black.withOpacity(.38),
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: FadeOpenPageTransitionsBuilder(),
          TargetPlatform.android: FadeOpenPageTransitionsBuilder(),
        },
      ),
    );
  }

  static MaterialColor _materialColorFromPalette(
      Palette? palette, bool primary) {
    if (palette == null) {
      return primary ? tbPrimary : tbAccent;
    }
    if (palette.type == 'custom') {
      var extendsColor = _colorFromType(palette.extendsPalette!);
      return _createMaterialColor(extendsColor);
    } else {
      return _colorFromType(palette.type);
    }
  }

  static MaterialColor _colorFromType(String? type) {
    switch (type) {
      case 'red':
        return Colors.red;
      case 'pink':
        return Colors.pink;
      case 'purple':
        return Colors.purple;
      case 'deep-purple':
        return Colors.deepPurple;
      case 'indigo':
        return Colors.indigo;
      case 'blue':
        return Colors.blue;
      case 'light-blue':
        return Colors.lightBlue;
      case 'cyan':
        return Colors.cyan;
      case 'teal':
        return Colors.teal;
      case 'green':
        return Colors.green;
      case 'light-green':
        return Colors.lightGreen;
      case 'lime':
        return Colors.lime;
      case 'yellow':
        return Colors.yellow;
      case 'amber':
        return Colors.amber;
      case 'orange':
        return Colors.orange;
      case 'deep-orange':
        return Colors.deepOrange;
      case 'brown':
        return Colors.brown;
      case 'grey':
        return Colors.grey;
      case 'blue-grey':
        return Colors.blueGrey;
      default:
        return tbPrimary; // Ensure default primary color is used
    }
  }

  static MaterialColor _createMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: color.withOpacity(0.1),
      100: color.withOpacity(0.2),
      200: color.withOpacity(0.3),
      300: color.withOpacity(0.4),
      400: color.withOpacity(0.5),
      500: color.withOpacity(0.6),
      600: color.withOpacity(0.7),
      700: color.withOpacity(0.8),
      800: color.withOpacity(0.9),
      900: color.withOpacity(1.0),
    });
  }
}