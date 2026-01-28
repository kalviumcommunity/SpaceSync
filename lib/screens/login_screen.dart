import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/mock_services.dart';
import '../main.dart'; // To access useMockServices
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (useMockServices) {
        // USE MOCK AUTH
        final auth = MockAuthService();
        await auth.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        // USE REAL FIREBASE AUTH
        final auth = AuthService();
        await auth.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      }
      // Navigation is handled by AuthWrapper
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? "Authentication failed";
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _googleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (useMockServices) {
         // Mock doesn't support Google, maybe show warning?
         setState(() {
           _errorMessage = "Google Sign In not supported in Mock Mode";
         });
      } else {
        final auth = AuthService();
        final userCredential = await auth.signInWithGoogle();
        
        // If login successful, ensure user data exists in Firestore
        if (userCredential != null && userCredential.user != null) {
           final firestore = FirestoreService();
           // We only want to set if new maybe? 
           // Or just update existing fields. 
           // For simplicity, let's just save (overwrite/merge) basic info
           await firestore.saveUserData(
             userCredential.user!.uid,
             userCredential.user!.email ?? '',
             userCredential.user!.displayName ?? 'Google User',
           );
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? "Google Sign In failed";
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _goToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (useMockServices)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(8),
                color: Colors.orange[100],
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                        child: Text("Running in DEMO MODE (Mock Backend)",
                            style: TextStyle(color: Colors.orange))),
                  ],
                ),
              ),
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 16),
                color: Colors.red[100],
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Login'),
              ),
            const SizedBox(height: 16),
            if (!_isLoading)
              OutlinedButton.icon(
                onPressed: _googleSignIn,
                icon: const Icon(Icons.login),
                label: const Text("Sign in with Google"),
              ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _goToSignup,
              child: const Text('Create an account'),
            ),
          ],
        ),
      ),
    );
  }
}
