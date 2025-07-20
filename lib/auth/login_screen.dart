import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _email = '';
  String _password = '';
  String _error = '';
  String _emailError = '';
  String _passwordError = '';
  bool _hasAttemptedSubmit = false;

  void _submit() async {
    setState(() {
      _hasAttemptedSubmit = true;
      _emailError = _emailController.text.isEmpty ? 'Enter an email' : '';
      _passwordError = _passwordController.text.isEmpty ? 'Enter a password' : '';
    });

    if (_emailError.isEmpty && _passwordError.isEmpty) {
      _email = _emailController.text;
      _password = _passwordController.text;
      
      try {
        await AuthService().signIn(_email, _password);
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
        _passwordError = value.isEmpty ? 'Enter a password' : '';
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                color: Colors.grey,
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
        backgroundColor: const Color.fromARGB(255, 253, 253, 253),
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
                    FractionallySizedBox(
                      widthFactor: 0.73,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 38,
                            child: TextField(
                              controller: _emailController,
                              onChanged: _onEmailChanged,
                              decoration: InputDecoration(
                                labelText: 'Email',
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
                          if (_emailError.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 4),
                              child: Text(
                                _emailError,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.red,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    FractionallySizedBox(
                      widthFactor: 0.73,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 38,
                            child: TextField(
                              controller: _passwordController,
                              onChanged: _onPasswordChanged,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
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
                          if (_passwordError.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 4),
                              child: Text(
                                _passwordError,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.red,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
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
                            'Log In',
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
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      child: const Text(
                        'Need an account? Sign up',
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
}