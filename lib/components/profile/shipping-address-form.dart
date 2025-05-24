import 'package:android_studio_projects/components/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../order/payment.dart';
import '../../providers/theme.provider.dart';
import '../../utils/utils.dart';

class ShippingAddressForm extends StatefulWidget {
  final bool isPaymentMode;
  final dynamic orderDetails;

  ShippingAddressForm({this.isPaymentMode = false, this.orderDetails});

  @override
  _ShippingAddressFormState createState() => _ShippingAddressFormState();
}

class _ShippingAddressFormState extends State<ShippingAddressForm> {
  final addressFormKey = GlobalKey<FormState>();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadUserAddress();
  }

  Future<void> loadUserAddress() async {
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      DocumentSnapshot userAddressData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('address')
          .doc('shipping')
          .get();
      if (userAddressData.exists) {
        setState(() {
          zipController.text = userAddressData['zip'].toString();
          cityController.text = userAddressData['city'] ?? '';
          addressController.text = userAddressData['address'] ?? '';
          notesController.text = userAddressData['notes'] ?? '';
          phoneController.text = userData['phone'] ?? '';
        });
      }
    }
  }

  Future<void> updateUserAddress() async {
    if (user == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('address')
          .doc('shipping')
          .update({
        'zip': zipController.text.trim(),
        'city': cityController.text.trim(),
        'address': addressController.text.trim(),
        'notes': notesController.text.trim(),
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'phone': phoneController.text.trim(),
      });
      Utils.showSnackBar(
          Locales.string(context, 'shipping_address_update_success'),
          'success');
    } catch (error) {
      Utils.showSnackBar(
          Locales.string(context, 'shipping_address_update_error'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final nation = Locales.currentLocale(context)?.languageCode;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeMode = themeProvider.themeMode;
    return FutureBuilder<DocumentSnapshot>(
        future: user != null
            ? FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .get()
            : null,
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Scaffold(
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight + 10),
                    child: Container(
                      color: Colors.red,
                      padding: EdgeInsets.only(top: 10),
                      child: AppBar(
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        iconTheme: IconThemeData(color: Colors.black),
                        title: LocaleText(
                          'shipping_address',
                          style: GoogleFonts.cabin(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    )),
                body: Center(
                    child: SpinKitDualRing(
                  color: Colors.red,
                  size: 40.0,
                )));
          }
          return Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight + 10),
                child: Container(
                  color: Colors.red,
                  padding: EdgeInsets.only(top: 10),
                  child: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    iconTheme: IconThemeData(color: Colors.black),
                    title: LocaleText(
                      'shipping_address',
                      style: GoogleFonts.cabin(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                )),
            body: Form(
              key: addressFormKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Hooodies!",
                      style:
                          GoogleFonts.lobster(fontSize: 50, color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    _buildCountryField(nation!, themeMode),
                    const SizedBox(height: 20),
                    _buildZipField(nation, themeMode),
                    const SizedBox(height: 20),
                    _buildCityField(nation, themeMode),
                    const SizedBox(height: 20),
                    _buildAddressField(nation, themeMode),
                    const SizedBox(height: 20),
                    _buildNotesFields(nation, themeMode),
                    const SizedBox(height: 20),
                    _buildPhoneNotificationField(nation, themeMode),
                    const SizedBox(height: 30),
                    widget.isPaymentMode
                        ? ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(8.0, 50.0),
                            ),
                            icon: const Icon(Icons.payment_rounded,
                                size: 32, color: Colors.black),
                            label: Text(
                              'Pay',
                              style: GoogleFonts.cabin(
                                  fontSize: 24, color: Colors.black),
                            ),
                            onPressed: () {
                              final isValid =
                                  addressFormKey.currentState!.validate();
                              if (!isValid) {
                                return;
                              }
                              ;
                              Navigator.of(context).push(PageTransition(
                                type: PageTransitionType.fade,
                                child: PaymentBackground(),
                              ));
                            },
                          )
                        : ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(8.0, 50.0),
                            ),
                            icon: const Icon(Icons.save_alt_outlined,
                                size: 32, color: Colors.black),
                            label: LocaleText(
                              'save',
                              style: GoogleFonts.cabin(
                                  fontSize: 24, color: Colors.black),
                            ),
                            onPressed: () {
                              updateUserAddress();
                              if (!widget.isPaymentMode) {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: ProfilePage()),
                                );
                              }
                            },
                          ),
                    const SizedBox(height: 40)
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildCountryField(String languageCode, ThemeMode themeMode) {
    return _buildTextField(
      label: Locales.string(context, 'country'),
      controller: TextEditingController(text: "Magyarország"),
      languageCode: languageCode,
      themeMode: themeMode,
      isReadOnly: true,
    );
  }

  Widget _buildZipField(String languageCode, ThemeMode themeMode) {
    return _buildTextField(
      label: Locales.string(context, 'zip'),
      controller: zipController,
      languageCode: languageCode,
      themeMode: themeMode,
      isRequired: widget.isPaymentMode,
    );
  }

  Widget _buildCityField(String languageCode, ThemeMode themeMode) {
    return _buildTextField(
      label: Locales.string(context, 'city'),
      controller: cityController,
      languageCode: languageCode,
      themeMode: themeMode,
      isRequired: widget.isPaymentMode,
    );
  }

  Widget _buildAddressField(String languageCode, ThemeMode themeMode) {
    return _buildTextField(
      label: Locales.string(context, 'address'),
      controller: addressController,
      languageCode: languageCode,
      themeMode: themeMode,
      isRequired: widget.isPaymentMode,
    );
  }

  Widget _buildNotesFields(String languageCode, ThemeMode themeMode) {
    return Column(
      children: [
        _buildTextField(
          label: Locales.string(context, 'additional_notes_optional'),
          controller: notesController,
          languageCode: languageCode,
          themeMode: themeMode,
        ),
      ],
    );
  }

  Widget _buildPhoneNotificationField(
      String languageCode, ThemeMode themeMode) {
    return _buildTextField(
      label: Locales.string(context, 'phone_optional'),
      controller: phoneController,
      languageCode: languageCode,
      themeMode: themeMode,
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String languageCode,
    required ThemeMode themeMode,
    bool isReadOnly = false,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.cabin(
            color: Colors.grey.shade500,
            fontSize: 15,
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            isDense: true,
          ),
          style: TextStyle(
              color: isReadOnly
                  ? (themeMode == ThemeMode.light
                      ? Colors.black54
                      : Colors.white54)
                  : (themeMode == ThemeMode.light
                      ? Colors.black
                      : Colors.white)),
          controller: controller,
          textAlign: TextAlign.center,
          readOnly: isReadOnly,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: isRequired
              ? (value) => (value != null && value.length == 0)
                  ? Locales.string(context, 'field_cannot_be_empty')
                  : null
              : null,
        ),
      ],
    );
  }
}
