import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mindease/features/auth/screens/register_screen.dart';
// Note: Adjust the import paths above if your folder structure is slightly different

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

    @override
    State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    bool _isLoading = false;
    bool _obscurePassword = true;

    Future<void> _handleLogin() async {
        // Basic validation
        if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password")),
      );
            return;
        }

        setState(() => _isLoading = true);

        try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
      );
            // If successful, AuthWrapper will automatically navigate to HomeScreen!
        } on FirebaseAuthException catch (e) {
                String message = "An error occurred during login.";
        if (e.code == 'user-not-found') {
            message = "No user found for that email.";
        } else if (e.code == 'wrong-password') {
            message = "Wrong password provided.";
        } else if (e.code == 'invalid-email') {
            message = "The email address is badly formatted.";
        }

        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }
    } finally {
            if (mounted) {
                setState(() => _isLoading = false);
            }
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
        final theme = Theme.of(context);
        final size = MediaQuery.of(context).size;

        return Scaffold(
                body: SafeArea(
                child: Center(
                // SingleChildScrollView + ConstrainedBox makes it responsive
                // and prevents keyboard overflow
                child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500), // Looks good on tablets too
        child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

        // Logo or Icon
        Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
                    ),
        child: Icon(
                Icons.self_improvement_rounded,
                size: 50,
                color: theme.colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 30),

        // Welcome Text
        Text(
                "Welcome Back",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
        Text(
                "Sign in to continue your mindfulness journey",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),

                  const SizedBox(height: 40),

        // Login Form Card
        Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: theme.colorScheme.primary.withOpacity(0.05)),
        boxShadow: [
        BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.05),
                blurRadius: 24,
                offset: const Offset(0, 8),
                        ),
                      ],
                    ),
        child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
        // Email Field
        Text(
                "Email Address",
                style: TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 8),
        TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                hintText: "hello@mindease.com",
                prefixIcon: Icon(Icons.email_outlined, color: theme.colorScheme.primary),
        filled: true,
                fillColor: theme.colorScheme.primary.withOpacity(0.05),
                border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

        // Password Field
        Text(
                "Password",
                style: TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 8),
        TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                hintText: "••••••••",
                prefixIcon: Icon(Icons.lock_outline_rounded, color: theme.colorScheme.primary),
        suffixIcon: IconButton(
                icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
                              ),
        onPressed: () {
            setState(() {
                _obscurePassword = !_obscurePassword;
            });
        },
                            ),
        filled: true,
                fillColor: theme.colorScheme.primary.withOpacity(0.05),
                border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

        // Forgot Password Link (Placeholder)
        Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Forgot password coming soon!")),
                              );
        },
        child: Text(
                "Forgot Password?",
                style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

        // Login Button
        SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
        onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                "Sign In",
                style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

        // Register Link
        Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
        Text(
                "Don't have an account?",
                style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                      ),
        TextButton(
                onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
        },
        child: Text(
                "Create one",
                style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    }
}