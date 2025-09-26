import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../routes.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController(text: 'admin@example.com');
  final passCtrl = TextEditingController(text: '123456');

  bool _loading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    final auth = context.read<AuthController>();

    final ok = await auth.login(emailCtrl.text.trim(), passCtrl.text.trim());
    setState(() => _loading = false);

    if (ok && mounted) {
      Navigator.pushReplacementNamed(context, Routes.items);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'فشل تسجيل الدخول')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(controller: emailCtrl, label: 'البريد الإلكتروني'),
            const SizedBox(height: 12),
            CustomTextField(controller: passCtrl, label: 'كلمة المرور', obscure: true),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _login,
              child: const Text('دخول'),
            ),
          ],
        ),
      ),
    );
  }
}
