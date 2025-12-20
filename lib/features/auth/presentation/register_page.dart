import 'package:book_store/core/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../provider/auth_provider.dart';
import '../provider/auth_state.dart';
import 'login_page.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailC = TextEditingController();
    final passC = TextEditingController();

    ref.listen<AsyncValue<AuthState>>(
      authProvider,
      (prev, next) {
        final state = next.value;
        if (state == null) return;

        if (state.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showErrorSnackBar(context, state.errorMessage!);
            ref.read(authProvider.notifier).clearEvent();
          });
          return;
        }

        if (state.justRegistered) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSuccessSnackBar(
              context,
              'Registrasi berhasil, silakan login',
            );

            ref.read(authProvider.notifier).clearEvent();

            Future.delayed(const Duration(milliseconds: 600), () {
              Navigator.pop(context);
            });
          });
        }
      },
    );

    final authAsync = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4F46E5),
              Color(0xFF9333EA),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 30,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.person_add_alt_1,
                      size: 48,
                      color: Color(0xFF4F46E5),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      "Buat Akun Baru",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Daftarkan akunmu untuk mulai menggunakan Book Store",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    TextField(
                      controller: emailC,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: passC,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: authAsync.isLoading
                            ? null
                            : () {
                                ref
                                  .read(authProvider.notifier)
                                  .register(emailC.text, passC.text);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: authAsync.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Sudah punya akun? Login"),
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
