import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

Future sendEmails(
    String orderId, List<Map<String, dynamic>> orderedProducts) async {
  DocumentSnapshot userData = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  Map<String, dynamic> common = {
    'firstName': userData['firstName'] ?? '',
    'lastName': userData['lastName'] ?? '',
    'orderId': orderId,
    'orders': orderedProducts
        .map((item) => {
              'productName': item['productId'],
              'size': item['size'],
              'quantity': item['quantity'],
              'groupPrice':
                  '${item['quantity']}x ${item['prices']['HUF']['raw']} Ft'
            })
        .toList(),
    'shippingCost': '20 Ft',
    'totalPrice': '100 Ft'
  };
  // await sendCustomerEmail(common);
  // await sendManufacturerEmail(common);
}

Future sendCustomerEmail(Map<String, dynamic> common) async {
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
        'template_params': common,
      }));
}

Future sendManufacturerEmail(Map<String, dynamic> common) async {
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
        'template_params': common,
      }));
}
