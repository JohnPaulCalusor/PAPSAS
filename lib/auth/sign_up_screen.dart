import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/common/validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  
  String _email = '';
  String _password = '';
  String _fullName = '';
  String _membershipType = 'Regular';
  String _region = 'Region 1';
  String _error = '';
  
  // Error states for manual validation
  String _emailError = '';
  String _passwordError = '';
  String _fullNameError = '';
  bool _hasAttemptedSubmit = false;

  void _submit() async {
    setState(() {
      _hasAttemptedSubmit = true;
      _emailError = _emailController.text.isEmpty ? 'Enter an email' : '';
      _passwordError = _passwordController.text.length < 6 ? 'Password must be at least 6 characters' : '';
      _fullNameError = _fullNameController.text.isEmpty ? 'Enter your full name' : '';
    });

    if (_emailError.isEmpty && _passwordError.isEmpty && _fullNameError.isEmpty) {
      _email = _emailController.text;
      _password = _passwordController.text;
      _fullName = _fullNameController.text;
      
      if (!isValidDomain(_email, _region)) {
        setState(() {
          _error = 'Email domain does not match selected region';
        });
        return;
      }
      try {
        await AuthService().signUp(
          email: _email,
          password: _password,
          fullName: _fullName,
          membershipType: _membershipType,
          region: _region,
        );
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        setState(() {
          _error = e.toString();
        });
      }
    }
  }

  void _onEmailChanged(String value) {
    if (_hasAttemptedSubmit) {
      setState(() {
        _emailError = value.isEmpty ? 'Enter an email' : '';
      });
    }
  }

  void _onPasswordChanged(String value) {
    if (_hasAttemptedSubmit) {
      setState(() {
        _passwordError = value.length < 6 ? 'Password must be at least 6 characters' : '';
      });
    }
  }

  void _onFullNameChanged(String value) {
    if (_hasAttemptedSubmit) {
      setState(() {
        _fullNameError = value.isEmpty ? 'Enter your full name' : '';
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/papsas_logo.png',
              width: 36,
              height: 36,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image_not_supported,
                color: Color.fromARGB(255, 118, 117, 117),
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'PAPSAS INC.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD32F2F), Color(0xFF8B0000)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 32.0),
            child: Container(
              width: isMobile ? MediaQuery.of(context).size.width * 0.8 : 350,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/papsas_logo.png',
                      width: isMobile ? 100 : 120,
                      height: isMobile ? 100 : 120,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: isMobile ? 50 : 60,
                      ),
                    ),
                    SizedBox(height: isMobile ? 16 : 24),

                    // Email
                    customFormField(
                      controller: _emailController,
                      label: 'Email',
                      onChanged: _onEmailChanged,
                      errorText: _emailError,
                    ),

                    // Password
                    const SizedBox(height: 12),
                    customFormField(
                      controller: _passwordController,
                      label: 'Password',
                      obscure: true,
                      onChanged: _onPasswordChanged,
                      errorText: _passwordError,
                    ),

                    // Full Name
                    const SizedBox(height: 12),
                    customFormField(
                      controller: _fullNameController,
                      label: 'Full Name',
                      onChanged: _onFullNameChanged,
                      errorText: _fullNameError,
                    ),

                    // Membership Type
                    const SizedBox(height: 12),
                    dropdownField(
                      label: 'Membership Type',
                      value: _membershipType,
                      items: ['Regular', 'Special', 'Affiliate', 'Lifetime'],
                      onChanged: (val) => setState(() => _membershipType = val!),
                    ),

                    // Region
                    const SizedBox(height: 12),
                    dropdownField(
                      label: 'Region',
                      value: _region,
                      items: List.generate(18, (i) => 'Region ${i + 1}'),
                      onChanged: (val) => setState(() => _region = val!),
                    ),

                    // Submit
                    SizedBox(height: isMobile ? 16 : 24),
                    FractionallySizedBox(
                      widthFactor: 0.73,
                      child: SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (_error.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          _error,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.red,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      child: const Text(
                        'Already have an account? Log in',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customFormField({
    required TextEditingController controller,
    required String label,
    required Function(String) onChanged,
    required String errorText,
    bool obscure = false,
  }) {
    return FractionallySizedBox(
      widthFactor: 0.73,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 38,
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              obscureText: obscure,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(255, 143, 143, 143),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 216, 214, 214),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red.withOpacity(0.3)),
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red.withOpacity(0.5)),
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
              ),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
              ),
            ),
          ),
          if (errorText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 4),
              child: Text(
                errorText,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.red,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget dropdownField({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return FractionallySizedBox(
      widthFactor: 0.73,
      child: SizedBox(
        height: 38,
        child: DropdownButtonFormField<String>(
          value: value,
          items: items.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: Color.fromARGB(255, 143, 143, 143),
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 216, 214, 214),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black),
        ),
      ),
    );
  }
}