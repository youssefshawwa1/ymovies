import 'package:flutter/material.dart';
import 'dart:convert'; // For jsonEncode/decode
import 'package:http/http.dart' as http;
import "apiLinks.dart";

class LoginPage extends StatefulWidget {
  // We pass a Map now because there are many pieces of data
  final Function(
    Map<String, dynamic> userData,
    // Map<String, dynamic> configData,
    bool isSignUp,
  )
  onAuthComplete;

  const LoginPage({super.key, required this.onAuthComplete});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLogin = true;

  // Controllers for all fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  void _submit() async {
    final email = _emailController.text.trim();
    final password = _passController.text;
    final confirmPass = _confirmPassController.text;
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    // Basic Validation
    bool _isValidEmail(String email) {
      return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ).hasMatch(email);
    }

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("All fields are required!")));
      return;
    }
    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter a valid email!")));
      return;
    }
    if (!_isLogin) {
      if (password != confirmPass) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match!")),
        );
        return;
      }
      if (firstName.isEmpty || lastName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("All fields are required!!")),
        );
      }
    }

    Map<String, String> data = {
      'email': email,
      'password': password,
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
    };
    final String url = _isLogin
        ? '${apiLink}/login.php'
        : '${apiLink}/signup.php';

    void _showError(String msg) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    try {
      showDialog(
        context: context,
        builder: (context) =>
            const Center(child: CircularProgressIndicator(color: Colors.red)),
      );

      final response = await http.post(
        Uri.parse(url),
        body: {
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          'is_signup': (!_isLogin).toString(),
        },
      );
      Navigator.pop(context);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          // 5. Success! Extract the user data from your PHP response

          Map<String, dynamic> authData = {
            'userId': responseData['user_id'].toString(),
            'email': email,
            'firstName': responseData['first_name'] ?? firstName,
            'lastName': responseData['last_name'] ?? lastName,
          };
          widget.onAuthComplete(authData, !_isLogin);
        } else {
          _showError(responseData['message'] ?? "Authentication failed");
        }
      } else {
        _showError("Server error: ${response.statusCode}");
      }
    } catch (error) {
      Navigator.pop(context);
      _showError("Connection failed. Check your internet.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Added to prevent overflow when keyboard appears
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isLogin ? "Welcome Back" : "Create Account",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // --- SIGN UP ONLY FIELDS ---
              if (!_isLogin) ...[
                _buildTextField(_firstNameController, "First Name"),
                const SizedBox(height: 15),
                _buildTextField(_lastNameController, "Last Name"),
                const SizedBox(height: 15),
              ],

              // --- ALWAYS VISIBLE FIELD (EMAIL) ---
              _buildTextField(
                _emailController,
                "Email",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),

              // --- ALWAYS VISIBLE FIELD (PASSWORD) ---
              _buildTextField(_passController, "Password", isObscure: true),
              const SizedBox(height: 15),

              // --- SIGN UP ONLY FIELD (CONFIRM PASSWORD) ---
              if (!_isLogin) ...[
                _buildTextField(
                  _confirmPassController,
                  "Confirm Password",
                  isObscure: true,
                ),
                const SizedBox(height: 30),
              ],

              const SizedBox(height: 15),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: _submit,
                child: Text(
                  _isLogin ? "LOGIN" : "SIGN UP",
                  style: const TextStyle(fontSize: 18),
                ),
              ),

              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(
                  _isLogin
                      ? "Don't have an account? Sign Up"
                      : "Already have an account? Login",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to keep UI code clean
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isObscure = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
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
      ),
    );
  }
}
