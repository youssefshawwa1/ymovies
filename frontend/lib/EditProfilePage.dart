import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "AuthProvider.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import "apiLinks.dart";

//this widget, is  the profile edit page
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  //defining the form key
  final _formKey = GlobalKey<FormState>();

  //defining the text field controllers
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  bool _isChangingPassword = false;

  @override
  //initiaal staate, make sure to get the current user profile data, from the provider.
  void initState() {
    super.initState();
    final userData = context.read<AuthProvider>().userData;

    _firstNameController = TextEditingController(
      text: userData?["firstName"] ?? "",
    );
    _lastNameController = TextEditingController(
      text: userData?["lastName"] ?? "",
    );
    _emailController = TextEditingController(text: userData?["email"] ?? "");

    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  //after the widget goes, it should delete the text fields controller, for securitty.
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    //handling the save button.

    //if the form is validated then go on.
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();

      String userId = authProvider.userData?["userId"] ?? "";

      final updateData = {
        "userId": userId,
        "first_name": _firstNameController.text.trim(),
        "last_name": _lastNameController.text.trim(),
        "email": _emailController.text.trim(),
        "current_password": _currentPasswordController.text,
        if (_isChangingPassword) "new_password": _newPasswordController.text,
      };
      final url = Uri.parse('$apiLink/update_user.php');

      //sending the data to the api
      try {
        final response = await http.post(url, body: updateData);
        final res = json.decode(response.body);
        if (res["success"] == true) {
          context.read<AuthProvider>().updateLocalUserData({
            "firstName": res["data"]["first_name"],
            "lastName": res["data"]["last_name"],
            "email": res["data"]["email"],
            "userId": res["data"]["userId"],
          });
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
          setState(() => _isChangingPassword = false);
          _showError("Profile updated successfully!", color: Colors.green);
        } else {
          _showError(res['message'] ?? "Update failed");
        }
        if (res['success'] != true) throw Exception();
      } catch (e) {
        _showError("Connection failed. Please try again.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Matching common dark theme login pages
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Update Information",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // --- PERSONAL INFO ---
                _buildStyledField(_firstNameController, "First Name"),
                const SizedBox(height: 15),
                _buildStyledField(_lastNameController, "Last Name"),
                const SizedBox(height: 15),
                _buildStyledField(
                  _emailController,
                  "Email",
                  keyboardType: TextInputType.emailAddress,
                  isEmail: true,
                ),

                const SizedBox(height: 30),
                const Text(
                  "Security Verification",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                _buildStyledField(
                  _currentPasswordController,
                  "Current Password",
                  isObscure: true,
                ),

                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.grey),
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      "Change Password?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    value: _isChangingPassword,
                    activeColor: Colors.red,
                    onChanged: (val) =>
                        setState(() => _isChangingPassword = val!),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),

                if (_isChangingPassword) ...[
                  _buildStyledField(
                    _newPasswordController,
                    "New Password",
                    isObscure: true,
                  ),
                  const SizedBox(height: 15),
                  _buildStyledField(
                    _confirmPasswordController,
                    "Confirm New Password",
                    isObscure: true,
                    isConfirmField: true,
                  ),
                ],

                const SizedBox(height: 40),

                // --- SAVE BUTTON ---
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: _handleSave,
                  child: const Text(
                    "SAVE CHANGES",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showError(String msg, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  //build styled field, based on its type, and validate baased on its type.
  Widget _buildStyledField(
    TextEditingController controller,
    String label, {
    bool isObscure = false,
    TextInputType? keyboardType,
    bool isEmail = false,
    bool isConfirmField = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      cursorColor: Colors.red,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),

      //validatoin of the textfields.
      validator: (value) {
        if (value == null || value.isEmpty) {
          // Current password and profile info are required
          if (!isObscure || label == "Current Password")
            return "$label is required";
        }
        if (isObscure) {
          if (value!.length < 8) {
            return "Password must be at least 8 characters long";
          }
        }
        if (isEmail &&
            !RegExp(
              r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
            ).hasMatch(value!)) {
          return "Enter a valid email";
        }
        if (isConfirmField && value != _newPasswordController.text) {
          return "Passwords do not match";
        }
        return null;
      },
    );
  }
}
