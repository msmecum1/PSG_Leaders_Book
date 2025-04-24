import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:psg_leaders_book/providers/auth_provider.dart';
import 'package:psg_leaders_book/providers/firestore_provider.dart';
import 'package:psg_leaders_book/screens/login_screen.dart';
import 'package:psg_leaders_book/screens/main_menu_screen.dart';
import 'package:psg_leaders_book/screens/roster_report_screen.dart';
import 'package:psg_leaders_book/screens/task_org_diagram_screen.dart';
import 'firebase_options.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Use generated options
  );
  runApp(const MyApp());
}

// Rest of the file remains unchanged for now
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FirestoreProvider()),
      ],
      child: MaterialApp(
        title: 'PSG Leader\'s Book',
        theme: ThemeData(
          primarySwatch: Colors.grey,
          scaffoldBackgroundColor: Colors.grey[200],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthWrapper(),
          '/main': (context) => const MainMenuScreen(),
          '/roster': (context) => const RosterReportScreen(),
          '/taskOrg': (context) => const TaskOrgDiagramScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return authProvider.user == null
        ? const LoginScreen()
        : const MainMenuScreen();
  }
}
