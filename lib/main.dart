import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/themes/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/role_selection_screen.dart';
import 'features/kasir/screens/kasir_main_screen.dart';
import 'features/mekanik/screens/mekanik_main_screen.dart';
import 'core/constants/app_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            // Check if user is authenticated and has selected a role
            if (authProvider.isAuthenticated) {
              if (authProvider.userRole == AppConstants.roleKasir) {
                return const KasirMainScreen();
              } else if (authProvider.userRole == AppConstants.roleMekanik) {
                return const MekanikMainScreen();
              }
            }
            
            // Show role selection screen if not authenticated
            return const RoleSelectionScreen();
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
