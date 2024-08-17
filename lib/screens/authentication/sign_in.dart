import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/providers/auth_provider.dart';
import 'package:stock_manager/screens/authentication/reset_password.dart';
import 'package:stock_manager/widgets/custom_snackbar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    final authManager = Provider.of<AuthManager>(context, listen: true);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 104, 24, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: Image.asset('assets/images/logo.png'),
              ),
              const SizedBox(height: 40),
              _buildSignInForm(context, authManager),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm(BuildContext context, AuthManager authManager) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            controller: userController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(16),
              prefixIcon: Icon(Icons.account_circle),
              labelText: 'Email Address',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            controller: passwordController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                icon: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                ),
              ),
              labelText: 'Password',
              border: const OutlineInputBorder(),
            ),
            obscureText: isPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            onFieldSubmitted: (_) {
              // Call the function to handle form submission here
              _submitForm(authManager);
            },
          ),
          const SizedBox(height: 16),
          _buildForgotPasswordLink(context),
          const SizedBox(height: 24),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepOrangeAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                minimumSize: const Size.fromHeight(48),
                padding: const EdgeInsets.all(16),
              ),
              onPressed: authManager.isLoading
                  ? null
                  : () async {
                      _submitForm(authManager);
                    },
              child: authManager.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(),
                    )
                  : const Text(
                      'Sign In',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ))
        ],
      ),
    );
  }

  _buildForgotPasswordLink(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () async {
            // Implement forgot password functionality
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ResetPasswordScreen(),
                ));
          },
          child: const Text(
            'Forgot Password?',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm(AuthManager authManager) async {
    if (formKey.currentState!.validate()) {
      try {
        // Perform sign-in
        await authManager.signInWithEmailAndPassword(
          userController.text,
          passwordController.text,
        );
      } catch (e) {
        if (mounted) showSnackBar(context);
        userController.clear();
        passwordController.clear();
      }
    }
  }
}
