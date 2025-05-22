import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../providers/cart.provider.dart';
import '../language-based-email-texts.dart';
import 'currency.service.dart';

Future sendEmails(String orderId, String orderDate, CartProvider cartProvider,
    String languageCode) async {
  final currencyService = CurrencyService.instance;
  List<Map<String, dynamic>> orderedProducts = cartProvider.cartItems;
  final Map<String, dynamic> languageBasedTexts;

  DocumentSnapshot userData = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  DocumentSnapshot userAddressData = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('address')
      .doc('shipping')
      .get();

  String currency;
  String firstname;
  String lastname;
  String language;

  switch (languageCode) {
    case 'hu':
      currency = 'HUF';
      language = 'magyar';
      firstname = userData['lastname'] ?? '';
      lastname = userData['firstname'] ?? '';
      break;
    case 'en':
      currency = 'USD';
      language = 'angol';
      firstname = userData['firstname'] ?? '';
      lastname = userData['lastname'] ?? '';
    case 'es':
      currency = 'EUR';
      language = 'spanyol';
      firstname = userData['firstname'] ?? '';
      lastname = userData['lastname'] ?? '';
      break;
    case 'fr':
      currency = 'EUR';
      language = 'francia';
      firstname = userData['firstname'] ?? '';
      lastname = userData['lastname'] ?? '';
      break;
    case 'pt':
      currency = 'EUR';
      language = 'portugál';
      firstname = userData['firstname'] ?? '';
      lastname = userData['lastname'] ?? '';
      break;
    case 'it':
      currency = 'EUR';
      language = 'olasz';
      firstname = userData['firstname'] ?? '';
      lastname = userData['lastname'] ?? '';
      break;
    default:
      currency = 'EUR';
      language = 'német';
      firstname = userData['firstname'] ?? '';
      lastname = userData['lastname'] ?? '';
      break;
  }

  Map<String, dynamic> common = {
    'firstname': firstname,
    'lastname': lastname,
    'orderId': orderId,
    'orderDate': DateTime.parse(orderDate)
        .toIso8601String()
        .split('.')[0]
        .replaceAll('T', ' '),
    'language': language,
    'orders': orderedProducts
        .map((item) => {
              'productName': item['name'],
              'size': item['size'],
              'quantity': item['quantity'],
              'groupPrice':
                  '${item['quantity']}x ${item['prices'][currency]['formatted']}'
            })
        .toList(),
    'shippingAddress':
        '${userAddressData['zip']} ${userAddressData['city']}, ${userAddressData['address']}',
    'shippingCost': '-',
    'totalPrice':
        currencyService.format(cartProvider.sumPrice(languageCode), currency),
    'customerEmail': userData['email'] ?? '',
  };
  await sendCustomerEmail(common, languageCode);
  await sendManufacturerEmail(common);
}

Future sendCustomerEmail(
    Map<String, dynamic> common, String languageCode) async {
  final Map<String, dynamic> languageBasedTexts = {};

  switch (languageCode) {
    case 'hu':
      languageBasedTexts.addAll(common_hu);
      languageBasedTexts.addAll(customer_hu);
      break;
    case 'de':
      languageBasedTexts.addAll(common_de);
      languageBasedTexts.addAll(customer_de);
      break;
    case 'es':
      languageBasedTexts.addAll(common_es);
      languageBasedTexts.addAll(customer_es);
      break;
    case 'fr':
      languageBasedTexts.addAll(common_fr);
      languageBasedTexts.addAll(customer_fr);
      break;
    case 'pt':
      languageBasedTexts.addAll(common_pt);
      languageBasedTexts.addAll(customer_pt);
      break;
    case 'it':
      languageBasedTexts.addAll(common_it);
      languageBasedTexts.addAll(customer_it);
      break;
    default:
      languageBasedTexts.addAll(common_en);
      languageBasedTexts.addAll(customer_en);
  }

  final serviceId = 'service_ln0x71t';
  final templateId = 'template_53lv54i';
  final publicKey = 'dQlVebTOSSi4WVz6l';
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  await http.post(url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': publicKey,
        'template_params': {
          'toEmail': common['customerEmail'],
          ...common,
          ...languageBasedTexts,
        }
      }));
}

Future sendManufacturerEmail(Map<String, dynamic> common) async {
  final Map<String, dynamic> languageBasedTexts = {}
    ..addAll(common_hu)
    ..addAll(manufacturer_hu);

  String email = '';
  String phone = '';
  String? uid = '';

  try {
    uid = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot userData =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    email = userData['email'];
    phone = userData['phone'];
  } catch (error) {
    print("An error occurred when fetching the customer's data!");
  }

  final Map<String, dynamic> customerData = {
    'email': email,
    'phone': phone,
    'userId': uid
  };

  final serviceId = 'service_ln0x71t';
  final templateId = 'template_vr4t6cg';
  final publicKey = 'dQlVebTOSSi4WVz6l';
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  await http.post(url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': publicKey,
        'template_params': {
          ...common,
          ...languageBasedTexts,
          ...customerData,
        }
      }));
}
