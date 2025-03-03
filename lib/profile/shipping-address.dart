import 'package:android_studio_projects/service/payment.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';

import '../service/order-email.service.dart';

class ShippingAddressPage extends StatefulWidget {
  final bool isPaymentMode;

  ShippingAddressPage({this.isPaymentMode = false});

  @override
  _ShippingAddressPageState createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController doorNumberController = TextEditingController();
  final TextEditingController doorBellController = TextEditingController();
  final TextEditingController entranceController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? addressType = "apartment";
  String? notificationType = "email";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 130),
            Text(
              "Shipping address",
              style: GoogleFonts.lobster(
                fontSize: 50,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 40),
            // Common Fields
            _buildCountryField(),
            const SizedBox(height: 30),
            _buildPostalCodeField(),
            const SizedBox(height: 30),
            _buildCityField(),
            const SizedBox(height: 30),
            _buildStreetAddressField(),
            const SizedBox(height: 30),
            // Address Type Selection
            _buildAddressTypeSelector(),
            const SizedBox(height: 30),
            // Fields based on address type
            if (addressType == "apartment") _buildApartmentFields(),
            const SizedBox(height: 30),
            if (addressType == "house") _buildHouseFields(),
            const SizedBox(height: 30),
            if (addressType == "company") _buildCompanyFields(),
            const SizedBox(height: 30),
            _buildNotesFields(),
            const SizedBox(height: 30),
            _buildNotificationSelector(),
            const SizedBox(height: 30),
            if (notificationType == "email") _buildEmailNotificationField(),
            if (notificationType == "phone") _buildPhoneNotificationField(),
            const SizedBox(height: 40),
            // Button - Save or Payment depending on the mode
            widget.isPaymentMode
                ? ElevatedButton(
                    onPressed: () {
                      if (_validateFields()) {
                        StripeService.instance.makePayment();
                      } else {
                        // SnackBar üzenet hiányzó mezőkről
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Kérlek, töltsd ki az összes kötelező mezőt!"),
                          ),
                        );
                        sendEmail();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.green,
                    ),
                    child: LocaleText(
                      'pay',
                      style: GoogleFonts.cabin(fontSize: 18),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      // Save logic
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.grey.shade300,
                    ),
                    child: LocaleText(
                      'save',
                      style: GoogleFonts.cabin(fontSize: 18),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  bool _validateFields() {
    if (postalCodeController.text.isEmpty ||
        cityController.text.isEmpty ||
        streetAddressController.text.isEmpty) {
      return false;
    }
    switch (addressType) {
      case 'apartment':
        if (floorController.text.isEmpty ||
            doorNumberController.text.isEmpty ||
            entranceController.text.isEmpty) {
          return false;
        }
        break;
      case 'house':
        if (doorBellController.text.isEmpty) {
          return false;
        }
        break;
      case 'company':
        if (companyController.text.isEmpty) {
          return false;
        }
    }
    switch (notificationType) {
      case 'email':
        if (!EmailValidator.validate(emailController.text)) {
          return false;
        }
        break;
      case 'phone':
        if (phoneController.text.isEmpty) {
          return false;
        }
    }
    return true;
  }

  // Common Fields
  Widget _buildCountryField() {
    return _buildTextField(
      label: 'country',
      controller: TextEditingController(text: "Magyarország"),
      isReadOnly: true,
    );
  }

  Widget _buildPostalCodeField() {
    return _buildTextField(
      label: 'postal_code',
      controller: postalCodeController,
      isRequired: widget.isPaymentMode,
    );
  }

  Widget _buildCityField() {
    return _buildTextField(
      label: 'city',
      controller: cityController,
      isRequired: widget.isPaymentMode,
    );
  }

  // Street Address below city field
  Widget _buildStreetAddressField() {
    return _buildTextField(
      label: 'street_address',
      controller: streetAddressController,
      isRequired: widget.isPaymentMode,
    );
  }

  // Address Type Selector (Radio buttons)
  Widget _buildAddressTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'address_type',
          style: GoogleFonts.cabin(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            _buildRadioButton('apartment', 'Lakás'),
            _buildRadioButton('house', 'Ház'),
            _buildRadioButton('company', 'Cég'),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioButton(String value, String label) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: addressType,
          onChanged: (String? newValue) {
            setState(() {
              addressType = newValue;
            });
          },
        ),
        Text(label),
      ],
    );
  }

  // Fields based on address type
  Widget _buildApartmentFields() {
    return Column(
      children: [
        _buildTextField(label: 'floor', controller: floorController),
        _buildTextField(label: 'door_number', controller: doorNumberController),
        _buildTextField(label: 'entrance', controller: entranceController),
      ],
    );
  }

  Widget _buildHouseFields() {
    return Column(
      children: [
        _buildTextField(label: 'door_bell', controller: doorBellController),
      ],
    );
  }

  Widget _buildCompanyFields() {
    return Column(
      children: [
        _buildTextField(label: 'company_name', controller: companyController),
      ],
    );
  }

  Widget _buildNotesFields() {
    return Column(
      children: [
        _buildTextField(
            label: 'additional_notes', controller: entranceController),
      ],
    );
  }

  // Notification Method Selection
  Widget _buildNotificationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'notification_method',
          style: GoogleFonts.cabin(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            _buildRadioButtonNotification('email', 'Email'),
            _buildRadioButtonNotification('phone', 'Telefon'),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioButtonNotification(String value, String label) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: notificationType,
          onChanged: (String? newValue) {
            setState(() {
              notificationType = newValue;
            });
          },
        ),
        Text(label),
      ],
    );
  }

  // Email Notification Field
  Widget _buildEmailNotificationField() {
    return _buildTextField(
      label: 'email',
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      isRequired: widget.isPaymentMode,
    );
  }

  Widget _buildPhoneNotificationField() {
    return _buildTextField(
      label: 'phone',
      controller: phoneController,
      keyboardType: TextInputType.phone, // Numerikus billentyűzet beállítása
      isRequired: widget.isPaymentMode,
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isReadOnly = false,
    bool isRequired = false,
    TextInputType keyboardType =
        TextInputType.text, // Alapértelmezett érték text
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
          controller: controller,
          cursorColor: Colors.black,
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          readOnly: isReadOnly,
          keyboardType: keyboardType,
          validator: isRequired
              ? (value) =>
                  value?.isEmpty ?? true ? 'This field is required' : null
              : null,
        ),
      ],
    );
  }
}
