import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class OrderCreationService {
  OrderCreationService._();

  static final OrderCreationService instance = OrderCreationService._();

  Future<String> create(List<Map<String, dynamic>> orderedProducts) async {
    const attempts = 10;
    try {
      final userId = await FirebaseAuth.instance.currentUser!.uid;
      for (int attempt = 0; attempt < attempts; attempt++) {
        final orderId = generateOrderId();
        final docSnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .get();
        if (!docSnapshot.exists) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(orderId)
              .set({
            'orderÍd': orderId,
            'customerId': userId,
            'orderDate': getTime(),
          });
          for (var product in orderedProducts) {
            await FirebaseFirestore.instance
                .collection('orders')
                .doc(orderId)
                .collection('products')
                .doc(product['productId'])
                .set({'productId': product['productId']});
            await FirebaseFirestore.instance
                .collection('orders')
                .doc(orderId)
                .collection('products')
                .doc(product['productId'])
                .collection('sizes')
                .doc(product['size'])
                .set({'quantity': product['quantity']});
          }
          return orderId;
        }
      }
    } catch (error) {
      print('Error caught during order-creation! | Reason: $error');
    }
    print('Order generation was not successful after $attempts tries.');
    return '';
  }

  String getTime() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDateTime = formatter.format(now);
    return formattedDateTime;
  }

  String generateOrderId() {
    const prefix = "HDS";
    const length = 8;
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    String randomString =
        List.generate(length, (index) => chars[random.nextInt(chars.length)])
            .join();
    return '$prefix$randomString';
  }
}
