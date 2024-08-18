import 'package:flutter/widgets.dart';
import 'package:rt_db_univercity_app/pages/home_page.dart';
import 'package:rt_db_univercity_app/service/auth_service.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService.auth.authStateChanges(),
      builder: (context, snapshot) {
        return snapshot.hasData ? const HomePage() : const HomePage();
      },
    );
  }
}
