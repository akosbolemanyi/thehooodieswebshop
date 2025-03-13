import 'dart:convert';
import 'package:http/http.dart' as http;

Future sendCustomerEmail() async {
  final serviceId = 'service_ln0x71t';
  final templateId = 'template_vr4t6cg';
  final publicKey = 'dQlVebTOSSi4WVz6l';
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  final response = await http.post(url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': publicKey,
        'template_params': {
          'firstname': 'Ákos',
          'lastname': 'Bolemányi',
          'products': 'One hooodie...'
        }
      }));

  print('This is the response: ${response.body}');
}

// TODO - Connect the new template and modify the identifiers accordingly below!
Future sendManufacturerEmail() async {
  final serviceId = 'service_ln0x71t';
  final templateId = 'template_vr4t6cg';
  final publicKey = 'dQlVebTOSSi4WVz6l';
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  final response = await http.post(url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': publicKey,
        'template_params': {
          'firstname': 'Ákos',
          'lastname': 'Bolemányi',
          'products': 'One hooodie...'
        }
      }));

  print('This is the response: ${response.body}');
}
