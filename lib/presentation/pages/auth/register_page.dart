import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/loader_overlay.dart';
import '../../viewmodels/auth/auth_viewmodel.dart';
import '../../../data/datasources/firebase/auth_service.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewModelProvider.select((s) => s.isLoading));

    return LoaderOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _name,
                        validator: (v) => Validators.required(v, label: 'Nama'),
                        decoration: const InputDecoration(labelText: 'Nama'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _email,
                        validator: Validators.email,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _pass,
                        validator: Validators.password,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscure = !_obscure),
                            icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;
                            try {
                              await ref.read(authViewModelProvider.notifier).register(
                                    name: _name.text.trim(),
                                    email: _email.text.trim(),
                                    password: _pass.text,
                                  );
                              // Requirement: register success -> back to login
                              if (context.mounted) {
                                AppToast.show(context, 'Register berhasil. Silakan login.', ToastType.success);
                                context.go('/login');
                              }
                            } on FirebaseAuthException catch (e) {
                              AppToast.show(context, AuthService.mapError(e), ToastType.error);
                            } catch (e) {
                              AppToast.show(context, e.toString(), ToastType.error);
                            }
                          },
                          child: const Text('Register'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: const Text('Sudah punya akun? Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}