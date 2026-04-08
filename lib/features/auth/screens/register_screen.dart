import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final reasonController = TextEditingController();

  String selectedGender = "Male";
  String selectedAge = "18-24";

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    // Basic validation
    if (usernameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Send verification email
      await credential.user!.sendEmailVerification();

      // Save user data in Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user!.uid)
          .set({
        "username": usernameController.text.trim(),
        "email": emailController.text.trim(),
        "gender": selectedGender,
        "age": selectedAge,
        "reason": reasonController.text.trim(),
        "createdAt": Timestamp.now(),
      });

      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      // Show Success Dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Icon(Icons.mark_email_read_rounded, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 10),
              const Text("Verify Email"),
            ],
          ),
          content: const Text(
            "A verification link has been sent to your email address.\nPlease verify your email before logging in.",
            style: TextStyle(height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to login screen
              },
              child: const Text("Go to Login", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );

    } on FirebaseAuthException catch (e) {
      String message = "Registration failed";
      if (e.code == 'weak-password') {
        message = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        message = "An account already exists for that email.";
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

  // Modernized Selection Row
  Widget buildSelectionRow(List<String> options, String selectedValue, Function(String) onTap) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((option) {
        final isSelected = selectedValue == option;

        return GestureDetector(
          onTap: () => onTap(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.transparent : theme.colorScheme.primary.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
                  : [],
            ),
            child: Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.8),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500), // Responsive max width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Header
                  Text(
                    "Create Account",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Join us and start your mindfulness journey today.",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Form Card
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

                        // Username
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            hintText: "Username",
                            prefixIcon: Icon(Icons.person_outline_rounded, color: theme.colorScheme.primary),
                            filled: true,
                            fillColor: theme.colorScheme.primary.withOpacity(0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Email
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Email Address",
                            prefixIcon: Icon(Icons.email_outlined, color: theme.colorScheme.primary),
                            filled: true,
                            fillColor: theme.colorScheme.primary.withOpacity(0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Password
                        TextField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: "Password",
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

                        const SizedBox(height: 30),

                        // Gender Selection
                        Text("Gender", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        buildSelectionRow(
                          ["Male", "Female", "Other"],
                          selectedGender,
                              (value) => setState(() => selectedGender = value),
                        ),

                        const SizedBox(height: 30),

                        // Age Selection
                        Text("Age Group", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        buildSelectionRow(
                          ["Below 14", "14-17", "18-24", "25-29", "30-39", "40+"],
                          selectedAge,
                              (value) => setState(() => selectedAge = value),
                        ),

                        const SizedBox(height: 30),

                        // Reason
                        Text("Your Goal", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        TextField(
                          controller: reasonController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Why do you want to use this app?",
                            filled: true,
                            fillColor: theme.colorScheme.primary.withOpacity(0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 35),

                        // Register Button
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
                            onPressed: _isLoading ? null : register,
                            child: _isLoading
                                ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                                : const Text(
                              "Create Account",
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

                  const SizedBox(height: 20), // Bottom padding
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}