import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/providers/auth_provider.dart';
import 'package:stock_manager/widgets/custom_dialog.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authManger = Provider.of<AuthManager>(context, listen: false);

    void showConfirmationDialog() async {
      FocusScope.of(context).unfocus();
      await showAbout(
        context,
        'Check Your Email',
        "Reset password link was sent to your email, follow the instruction to reset password.",
      );
      if (context.mounted) {
        Navigator.pop(context);
      }
    }

    void resetPassword() async {
      try {
        await authManger.resetPassword(_emailController.text.trim());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          if (context.mounted) {
            showAbout(
              context,
              'Invalid Email Address',
              'Please enter a valid email to sign up successfully.',
            );
          }
        } else if (e.code == 'user-not-found') {
          if (context.mounted) {
            showAbout(
              context,
              'User Not Found',
              "Please register your email first if you don't have an account to sign in successfully.",
            );
          }
        } else {
          if (context.mounted) {
            showAbout(
              context,
              'Reset Password Fail',
              "Please make sure that you have entered the correct email that you signed up with.",
            );
          }
        }
      }
    }

    void validateAndSubmit() {
      if (_formKey.currentState!.validate()) {
        // Email is valid, call the reset password function
        resetPassword();
        showConfirmationDialog();
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: _buildBackButton(context),
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTitle(context),
              const SizedBox(height: 8),
              _buildDescription(context),
              const SizedBox(height: 24.0),
              Form(
                key: _formKey,
                child: _buildResetPasswordTextField(context),
              ),
              const SizedBox(height: 24.0),
              _buildSubmitButton(validateAndSubmit),
            ],
          ),
        ),
      ),
    );
  }

  IconButton _buildBackButton(BuildContext context) {
    return IconButton(
      splashRadius: 24,
      icon: const Icon(
        Icons.close,
        size: 26,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Text _buildTitle(BuildContext context) {
    return const Text(
      'Reset Password',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      textAlign: TextAlign.justify,
    );
  }

  Text _buildDescription(BuildContext context) {
    return const Text(
      'Enter your email address to get the Password Reset Link',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16),
    );
  }

  TextFormField _buildResetPasswordTextField(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(16),
          border: OutlineInputBorder(),
          labelText: 'Email Address',
          hintText: 'sawnedah@gmail.com'),
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      autocorrect: false,
      controller: _emailController,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Email Address Required';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton(void Function() validateAndSubmit) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: validateAndSubmit,
        child: const Text(
          'Get the Link',
          style: TextStyle(
            // color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
