import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:intl/intl.dart';

class ProfileFormWidget extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController nicknameController;
  final TextEditingController birthDateController;
  final TextEditingController emailController;
  final bool isReadOnly;

  const ProfileFormWidget({
    Key? key,
    required this.firstNameController,
    required this.lastNameController,
    required this.nicknameController,
    required this.birthDateController,
    required this.emailController,
    this.isReadOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            isReadOnly ? "Profile Details" : "Edit Profile",
            style: GoogleFonts.lobster(
              fontSize: 40,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField(context, 'firstname', firstNameController),
          const SizedBox(height: 20),
          _buildTextField(context, 'lastname', lastNameController),
          const SizedBox(height: 20),
          _buildTextField(context, 'nickname_optional', nicknameController),
          const SizedBox(height: 20),
          _buildTextField(context, 'birthday', birthDateController, isDate: true),
          const SizedBox(height: 20),
          _buildTextField(context, 'email', emailController),
          if (!isReadOnly) ...[
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.save, size: 32, color: Colors.black),
              label: LocaleText(
                'save_changes',
                style: GoogleFonts.cabin(fontSize: 24, color: Colors.black),
              ),
              onPressed: () {
                // Itt lesz a mentés funkció
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String labelKey, TextEditingController controller, {bool isDate = false}) {
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
          controller: controller,
          readOnly: isReadOnly || isDate,
          decoration: InputDecoration(
            suffixIcon: isDate && !isReadOnly
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
                  controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
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
