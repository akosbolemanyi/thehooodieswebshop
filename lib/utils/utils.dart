import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/**
 * This class implements the general utils that the application uses. Now: the messaging through snack bars.
 */

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text, [String type = 'error']) {
    if (text == null) return;
    Color background;
    Color emblem;
    switch (type) {
      case 'success':
        background = Colors.green;
        emblem = Color(0xFF138036);
        break;
      case 'information':
        background = Colors.blueAccent;
        emblem = Color(0xFF1A366F);
        break;
      default:
        background = const Color(0xFFC72C41);
        emblem = const Color(0xFF801336);
    }
    final snackBar = SnackBar(
      content: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
              padding: const EdgeInsets.all(16),
              constraints: const BoxConstraints(minHeight: 90),
              decoration: BoxDecoration(
                  color: background, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  const SizedBox(
                    width: 48,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LocaleText(
                          type,
                          style: GoogleFonts.cabin(
                              fontSize: 18, color: Colors.white),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          text,
                          style: GoogleFonts.cabin(
                              fontSize: 13, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Positioned(
            bottom: 0,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.only(bottomLeft: Radius.circular(20)),
              child: SvgPicture.asset(
                "assets/images/bubbles.svg",
                height: 48,
                width: 40,
                color: emblem,
              ),
            ),
          ),
          Positioned(
              top: -10,
              left: 0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/fail.svg',
                    height: 40,
                    color: emblem,
                  ),
                  Positioned(
                    top: 10,
                    child: SvgPicture.asset(
                      'assets/images/close.svg',
                      height: 16,
                    ),
                  )
                ],
              ))
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
