import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../components/profile.dart';

class ProfileForm extends StatefulWidget {
  final bool isReadOnly;

  ProfileForm({this.isReadOnly = false});

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (userData.exists) {
        setState(() {
          firstNameController.text = userData['firstName'] ?? '';
          lastNameController.text = userData['lastName'] ?? '';
          nicknameController.text = userData['nickname'] ?? '';
          birthDateController.text = userData['birthday'] ?? '';
          emailController.text = userData['email'] ?? '';
        });
      }
    }
  }

  Future<void> updateProfile() async {
    if (user == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'nickname': nicknameController.text.trim(),
        'birthday': birthDateController.text.trim(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: user != null
          ? FirebaseFirestore.instance.collection('users').doc(user!.uid).get()
          : null,
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight + 15),
                child: Container(
                  color: Colors.red,
                  padding: EdgeInsets.only(top: 15),
                  child: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    iconTheme: IconThemeData(color: Colors.black),
                    title: Text(
                      'Profile details',
                      style: GoogleFonts.cabin(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    // backgroundColor: Colors.indigo.shade300,
                  ),
                )),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight + 15),
                child: Container(
                  color: Colors.red,
                  padding: EdgeInsets.only(top: 15),
                  child: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    iconTheme: IconThemeData(color: Colors.black),
                    title: Text(
                      'Profile details',
                      style: GoogleFonts.cabin(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    // backgroundColor: Colors.indigo.shade300,
                  ),
                )),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Hooodies!",
                    style: GoogleFonts.lobster(fontSize: 50, color: Colors.red),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(context, 'firstname', firstNameController),
                  const SizedBox(height: 30),
                  _buildTextField(context, 'lastname', lastNameController),
                  const SizedBox(height: 30),
                  _buildTextField(
                      context, 'nickname_optional', nicknameController),
                  const SizedBox(height: 30),
                  _buildTextField(context, 'birthday', birthDateController,
                      isDate: true),
                  const SizedBox(height: 30),
                  _buildTextField(context, 'email', emailController,
                      isNotModifiable: true),
                  const SizedBox(height: 40),
                  if (!widget.isReadOnly) ...[
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(8.0, 50.0),
                      ),
                      icon: const Icon(Icons.save_alt_outlined,
                          size: 32, color: Colors.black),
                      label: Text(
                        'Save',
                        style: GoogleFonts.cabin(
                            fontSize: 24, color: Colors.black),
                      ),
                      onPressed: () {
                        updateProfile();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()),
                        );
                      },
                    ),
                  ],
                  if (widget.isReadOnly) ...[
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        minimumSize: const Size(8.0, 50.0),
                      ),
                      icon: const Icon(Icons.draw_outlined,
                          size: 32, color: Colors.black),
                      label: Text(
                        'Edit profile',
                        style: GoogleFonts.cabin(
                            fontSize: 24, color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return ProfileForm();
                          }),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ));
      },
    );
  }

  Widget _buildTextField(
      BuildContext context, String labelKey, TextEditingController controller,
      {bool isDate = false, bool isNotModifiable = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LocaleText(
          labelKey,
          style: GoogleFonts.cabin(
            color: Colors.grey.shade500,
            fontSize: 15,
          ),
        ),
        TextFormField(
          textAlign: widget.isReadOnly || isNotModifiable
              ? TextAlign.center
              : TextAlign.start,
          controller: controller,
          textInputAction: TextInputAction.next,
          readOnly: widget.isReadOnly || isDate || isNotModifiable,
          decoration: InputDecoration(
            suffixIcon: isDate && !widget.isReadOnly
                ? IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        controller.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      }
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
