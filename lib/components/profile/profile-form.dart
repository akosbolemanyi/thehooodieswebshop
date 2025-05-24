import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../providers/theme.provider.dart';
import '../../utils/utils.dart';
import 'profile.dart';

class ProfileForm extends StatefulWidget {
  final bool isReadOnly;

  ProfileForm({this.isReadOnly = false});

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
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
          firstnameController.text = userData['firstname'] ?? '';
          lastnameController.text = userData['lastname'] ?? '';
          nicknameController.text = userData['nickname'] ?? '';
          birthDateController.text = userData['birthday'] ?? '';
          emailController.text = userData['email'] ?? '';
        });
      }
    }
  }

  Future<void> updateProfile() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    if (user == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'firstname': firstnameController.text.trim(),
        'lastname': lastnameController.text.trim(),
        'nickname': nicknameController.text.trim(),
        'birthday': birthDateController.text.trim(),
      });
      Utils.showSnackBar(
          Locales.string(context, 'profile_update_success'), 'success');
    } catch (error) {
      Utils.showSnackBar(Locales.string(context, 'profile_update_error'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeMode = themeProvider.themeMode;
    return FutureBuilder<DocumentSnapshot>(
      future: user != null
          ? FirebaseFirestore.instance.collection('users').doc(user!.uid).get()
          : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: SpinKitDualRing(
                color: Colors.red,
                size: 40.0,
              ),
            ),
          );
        }
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
                      'profile_details',
                      style: GoogleFonts.cabin(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    // backgroundColor: Colors.indigo.shade300,
                  ),
                )),
            body: Center(
              child: SpinKitDualRing(
                color: Colors.red,
                size: 40.0,
              ),
            ),
          );
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
                      'profile_details',
                      style: GoogleFonts.cabin(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    // backgroundColor: Colors.indigo.shade300,
                  ),
                )),
            body: Form(
              key: formKey,
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
                    _buildTextField(
                        context, 'lastname', lastnameController, themeMode),
                    const SizedBox(height: 20),
                    _buildTextField(
                        context, 'firstname', firstnameController, themeMode),
                    const SizedBox(height: 20),
                    _buildTextField(context, 'nickname_optional',
                        nicknameController, themeMode,
                        isRequired: false),
                    const SizedBox(height: 20),
                    _buildTextField(
                        context, 'birthday', birthDateController, themeMode,
                        isDate: true),
                    const SizedBox(height: 20),
                    _buildTextField(
                        context, 'email', emailController, themeMode,
                        isNotModifiable: true),
                    const SizedBox(height: 30),
                    if (!widget.isReadOnly) ...[
                      ElevatedButton.icon(
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
                          final isValid = formKey.currentState!.validate();
                          if (!isValid) return;
                          updateProfile();
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: ProfilePage()),
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
                        label: LocaleText(
                          'edit_profile',
                          style: GoogleFonts.cabin(
                              fontSize: 24, color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: ProfileForm()),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String labelKey,
    TextEditingController controller,
    ThemeMode themeMode, {
    bool isDate = false,
    bool isNotModifiable = false,
    bool isRequired = true,
  }) {
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
          style: TextStyle(
              color: isNotModifiable
                  ? (themeMode == ThemeMode.light
                      ? Colors.black54
                      : Colors.white54)
                  : (themeMode == ThemeMode.light
                      ? Colors.black
                      : Colors.white)),
          textAlign: widget.isReadOnly || isNotModifiable
              ? TextAlign.center
              : TextAlign.start,
          controller: controller,
          textInputAction: TextInputAction.next,
          readOnly: widget.isReadOnly || isDate || isNotModifiable,
          validator: (value) {
            if (!isRequired) {
              return null;
            }
            ;
            return (value == null || value.trim().isEmpty)
                ? Locales.string(context, 'field_cannot_be_empty')
                : null;
          },
          decoration: InputDecoration(
            isDense: true,
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
