import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../providers/cart.provider.dart';
import '../language-based-email-texts.dart';

Future sendEmails(String orderId, String orderDate, CartProvider cart,
    String languageCode) async {
  List<Map<String, dynamic>> orderedProducts = cart.cartItems;
  final Map<String, dynamic> languageBasedTexts;

  switch (languageCode) {
    case 'hu':
      languageBasedTexts = common_hu;
      break;
    case 'de':
      languageBasedTexts = common_de;
      break;
    default:
      languageBasedTexts = common_en;
  }

  DocumentSnapshot userData = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  String currency;
  String firstName;
  String lastName;
  String language;
  String totalPrice;

  switch (languageCode) {
    case 'hu':
      currency = 'HUF';
      language = 'magyar';
      totalPrice = cart.totalPriceHuf();
      firstName = userData['lastName'] ?? '{{firstName}}';
      lastName = userData['firstName'] ?? '{{lastName}}';
      break;
    case 'de':
      currency = 'EUR';
      language = 'német';
      totalPrice = cart.totalPriceEuro();
      firstName = userData['firstName'] ?? '';
      lastName = userData['lastName'] ?? '';
      break;
    default:
      currency = 'USD';
      language = 'angol';
      totalPrice = cart.totalPriceDollar();
      firstName = userData['firstName'] ?? '';
      lastName = userData['lastName'] ?? '';
  }

  Map<String, dynamic> common = {
    'firstName': firstName,
    'lastName': lastName,
    'orderId': orderId,
    'orderDate': orderDate,
    'language': language,
    'orders': orderedProducts
        .map((item) => {
              'productName': item['productId'],
              'size': item['size'],
              'quantity': item['quantity'],
              'groupPrice':
                  '${item['quantity']}x ${item['prices'][currency]['formatted']}'
            })
        .toList(),
    'shippingCost': '-',
    'totalPrice': totalPrice,
    ...languageBasedTexts,
  };
  await sendCustomerEmail(common, languageCode);
  await sendManufacturerEmail(common);
}

Future sendCustomerEmail(
    Map<String, dynamic> common, String languageCode) async {
  final Map<String, dynamic> languageBasedTexts;

  switch (languageCode) {
    case 'hu':
      languageBasedTexts = customer_hu;
      break;
    case 'de':
      languageBasedTexts = customer_de;
      break;
    default:
      languageBasedTexts = customer_en;
  }

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
        }
      }));
}

Future sendManufacturerEmail(Map<String, dynamic> common) async {
  final Map<String, dynamic> languageBasedTexts = manufacturer_hu;

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
          ...common,
          ...languageBasedTexts,
          ...customerData,
        }
      }));
}
