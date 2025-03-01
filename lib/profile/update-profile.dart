import 'package:android_studio_projects/model/user.model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: ProfileFormWidget(
        firstNameController: firstNameController,
        lastNameController: lastNameController,
        nicknameController: nicknameController,
        birthDateController: birthDateController,
        emailController: emailController,
        isReadOnly: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: updateProfile,
        backgroundColor: Colors.red,
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }
}

class ProfileDetailsPage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: user != null
          ? FirebaseFirestore.instance.collection('users').doc(user!.uid).get()
          : null,
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(title: Text("Profile Details")),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        var userData = snapshot.data!;
        return Scaffold(
          appBar: AppBar(title: Text("Profile Details")),
          body: ProfileFormWidget(
            firstNameController:
                TextEditingController(text: userData['firstName']),
            lastNameController:
                TextEditingController(text: userData['lastName']),
            nicknameController:
                TextEditingController(text: userData['nickname']),
            birthDateController:
                TextEditingController(text: userData['birthday']),
            emailController: TextEditingController(text: userData['email']),
            isReadOnly: true,
          ),
        );
      },
    );
  }
}
