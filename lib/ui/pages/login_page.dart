import 'package:flutter/material.dart';
import '../../providers/auth_provider.dart';
import '../../ui/widgets/custom_text_field.dart';
import '../../ui/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final success = await provider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (success) {
      final user = provider.user!;
      Navigator.pushReplacementNamed(
        context,
        user.isAdmin ? '/admin' : '/user',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please try again.')),
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
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 30),
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
              CustomButton(
                text: 'Login',
                onPressed: _login,
                isLoading:
                    Provider.of<AuthProvider>(context).user == null &&
                    context.watch<AuthProvider>().user != null,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text(
                  'Don’t have an account? Sign Up',
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
