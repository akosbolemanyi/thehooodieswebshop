import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../utils/utils.dart';
import '../menus/custom-side-menu.dart' as Sidebar;

/**
 * Here, the user can be navigated to the native phone or email application, or copy the contacts of the shop.
 */

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool _showMiniButtons = false;

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Utils.showSnackBar("Másolva: $text");
  }

  @override
  Widget build(BuildContext context) {
    final String _email = "hooodies@gmail.com";
    final String _phoneNumber = "+36 70/123-4567";
    final String _landPhoneNumber = "+36 27/123-456";
    return Scaffold(
      drawer: Sidebar.CustomSideMenu(),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 15),
          child: Container(
              color: Colors.red,
              padding: EdgeInsets.only(top: 15),
              child: AppBar(
                iconTheme: IconThemeData(color: Colors.black),
                title: LocaleText(
                  'menu_contact_us',
                  style: GoogleFonts.cabin(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ))),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: LocaleText(
                'contact_motto',
                textAlign: TextAlign.center,
                style: GoogleFonts.cabin(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              children: [
                LocaleText(
                  'contact_phone',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.tinos(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: LocaleText(
                        'contact_phone_num',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.tinos(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy, color: Colors.grey[600]),
                      onPressed: () => _copyToClipboard(_landPhoneNumber),
                    ),
                  ],
                )
              ],
            ),
            Column(
              children: [
                LocaleText(
                  'contact_mobile',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.tinos(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LocaleText(
                      'contact_mobile_num',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.tinos(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy, color: Colors.grey[600]),
                      onPressed: () => _copyToClipboard(_phoneNumber),
                    ),
                  ],
                )
              ],
            ),
            Divider(),
            Column(
              children: [
                LocaleText(
                  'contact_email',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.tinos(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LocaleText(
                      'contact_email_str',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.tinos(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy, color: Colors.grey[600]),
                      onPressed: () => _copyToClipboard(_email),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            if (_showMiniButtons) ...[
              Positioned(
                bottom: 75,
                right: 0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(10, 40),
                    backgroundColor: Colors.blue.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    final _call = 'tel:$_landPhoneNumber';
                    if (await canLaunchUrlString(_call)) {
                      await launchUrlString(_call);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.phone, color: Colors.white),
                      const SizedBox(width: 10),
                      LocaleText(
                        "phone",
                        style: GoogleFonts.cabin(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 135,
                right: 0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(10, 40),
                    backgroundColor: Colors.green.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    final _call = 'tel:$_phoneNumber';
                    if (await canLaunchUrlString(_call)) {
                      await launchUrlString(_call);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.smartphone, color: Colors.white),
                      const SizedBox(width: 10),
                      LocaleText(
                        "mobile",
                        style: GoogleFonts.cabin(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: "btn1",
                  backgroundColor: Colors.blue.shade400,
                  onPressed: () async {
                    await launchUrl(Uri.parse("mailto:$_email"));
                  },
                  child: const Icon(Icons.email),
                ),
                Expanded(child: Container()),
                FloatingActionButton(
                  heroTag: "btn2",
                  backgroundColor: Colors.green.shade400,
                  onPressed: () {
                    setState(() {
                      _showMiniButtons = !_showMiniButtons;
                    });
                  },
                  child: const Icon(Icons.call),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
