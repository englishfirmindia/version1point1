import 'package:flutter/material.dart';
import '../../providers/auth_provider.dart';
import '../../ui/widgets/custom_text_field.dart';
import '../../ui/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final success = await provider.signup(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signup successful! Redirecting to login...'),
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.person_add, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'Create an Account',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: _nameController,
                labelText: 'Full Name',
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                prefixIcon: Icons.email,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                prefixIcon: Icons.lock,
                obscureText: _obscurePassword,
                onToggleObscure:
                    () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              const SizedBox(height: 24),
              CustomButton(text: 'Sign Up', onPressed: _signup),
              const SizedBox(height: 16),
              TextButton(
                onPressed:
                    () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
