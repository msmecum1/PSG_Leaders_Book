import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psg_leaders_book/providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Store Navigator and ScaffoldMessenger before the async gap
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('PSG Leader\'s Book')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to PSG Leader\'s Book',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                // Async operation starts here
                final success = await authProvider.signInWithGoogle();
                // Async operation ends here

                // Use the stored variables after the await
                if (success) {
                  navigator.pushReplacementNamed(
                    '/main',
                  ); // Use stored navigator
                } else {
                  scaffoldMessenger.showSnackBar(
                    // Use stored scaffoldMessenger
                    const SnackBar(content: Text('Sign-in failed')),
                  );
                }
              },
              icon: const Icon(Icons.login),
              label: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
