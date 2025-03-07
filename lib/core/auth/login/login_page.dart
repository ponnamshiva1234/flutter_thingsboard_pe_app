import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:thingsboard_app/core/context/tb_context.dart';
import 'package:thingsboard_app/core/context/tb_context_widget.dart';
import 'package:thingsboard_app/thingsboard_client.dart';

class LoginPage extends TbPageWidget {
  LoginPage(TbContext tbContext, {super.key}) : super(tbContext);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends TbPageState<LoginPage> {
  final _loginFormKey = GlobalKey<FormBuilderState>();
  final _isLoginNotifier = ValueNotifier<bool>(false);
  final _showPasswordNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              Center(
                child: Image.asset(
                  'assets/images/mersino_logo.png',
                  width: 200,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

              // QR Code Login
              Center(
                child: Column(
                  children: [
                    const Text("Login with"),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _scanQRCode,
                      icon: const Icon(Icons.qr_code, size: 24, color: Colors.black), // QR Code icon
                      label: const Text("Scan QR Code"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        side: BorderSide(color: Colors.grey.shade400), // Button border color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Login Form
              FormBuilder(
                key: _loginFormKey,
                child: Column(
                  children: [
                    // Email Field
                    FormBuilderTextField(
                      name: 'username',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: 'Email is required'),
                        FormBuilderValidators.email(errorText: 'Enter a valid email'),
                      ]),
                    ),
                    const SizedBox(height: 20),

                    // Password Field with Eye Icon
                    ValueListenableBuilder<bool>(
                      valueListenable: _showPasswordNotifier,
                      builder: (context, showPassword, child) {
                        return FormBuilderTextField(
                          name: 'password',
                          obscureText: !showPassword,
                          validator: FormBuilderValidators.required(errorText: 'Password is required'),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                _showPasswordNotifier.value = !_showPasswordNotifier.value;
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _forgotPassword,
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Login Button
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Log In"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  QR Code Login Logic (No Errors)
  Future<void> _scanQRCode() async {
    try {
      final barcode = await widget.tbContext.navigateTo('/qrCodeScan');
      if (barcode != null && barcode.code != null) {
        widget.tbContext.navigateByAppLink(barcode.code);
      }
    } catch (e) {
      print("QR Code Login Error: $e");
    }
  }

  //  Login Logic (Shows "Invalid username or password" on failure)
  void _login() async {
    FocusScope.of(context).unfocus();

    if (_loginFormKey.currentState?.saveAndValidate() ?? false) {
      var formValue = _loginFormKey.currentState!.value;
      String username = formValue['username'];
      String password = formValue['password'];

      _isLoginNotifier.value = true; // Show loading indicator

      try {
        await widget.tbContext.tbClient.login(LoginRequest(username, password));

        // Get user details
        var authUser = widget.tbContext.tbClient.getAuthUser();
        print(" Login Successful! Authority: ${authUser?.authority}");

        // Navigation based on role
        if (authUser != null) {
          if (authUser.authority == "TENANT_ADMIN") {
            _navigateToDashboard();
          } else if (authUser.authority == "CUSTOMER_USER") {
            _navigateToCustomerDashboard();
          } else if (authUser.authority == "SYS_ADMIN") {
            _navigateToAdminPanel();
          } else {
            _showErrorMessage("❌ You do not have the required permissions.");
          }
        }

        _isLoginNotifier.value = false; // Stop loading

      } catch (e) {
        _isLoginNotifier.value = false; // Stop loading

        if (e is ThingsboardError) {
          if (e.errorCode == 10) {  // Error code 10 = Invalid credentials
            _showErrorMessage("❌ Invalid username or password!");
          } else {
            _showErrorMessage(e.message ?? "❌ Login failed. Please try again.");
          }
        } else {
          _showErrorMessage("❌ Something went wrong. Please check your network.");
        }
      }
    }
  }

  //  Navigation Fixes
  void _navigateToDashboard() {
    widget.tbContext.navigateTo('/dashboard'); // Corrected
  }

  void _navigateToCustomerDashboard() {
    widget.tbContext.navigateTo('/customerDashboard'); // Corrected
  }

  void _navigateToAdminPanel() {
    widget.tbContext.navigateTo('/admin'); // Corrected
  }

  //  Error Message Display
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  //  Forgot Password Navigation
  void _forgotPassword() {
    widget.tbContext.navigateTo('/login/resetPasswordRequest');
  }
}