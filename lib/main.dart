import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_colors.dart';
import 'screens/splash_screen.dart';
import 'screens/barrels_list_screen.dart';
import 'screens/pin_code_screen.dart';
import 'widgets/welcome_dialog.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OilTankApp());
}

class OilTankApp extends StatelessWidget {
  const OilTankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oil Tank Manager',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
        useMaterial3: true,
      ),
      home: SplashScreen(
        duration: const Duration(seconds: 4),
        child: PinCodeScreen(
          correctPin: '2580', // الرقم السري الجديد
          child: const MainAppWithWelcome(),
        ),
      ),
    );
  }
}

/// Main app wrapper that shows welcome dialog on first launch
class MainAppWithWelcome extends StatefulWidget {
  const MainAppWithWelcome({super.key});

  @override
  State<MainAppWithWelcome> createState() => _MainAppWithWelcomeState();
}

class _MainAppWithWelcomeState extends State<MainAppWithWelcome> {
  static const String _welcomeShownKey = 'welcome_shown';

  @override
  void initState() {
    super.initState();
    _checkAndShowWelcome();
  }

  Future<void> _checkAndShowWelcome() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final prefs = await SharedPreferences.getInstance();
    final welcomeShown = prefs.getBool(_welcomeShownKey) ?? false;

    if (!welcomeShown && mounted) {
      await WelcomeDialog.show(context);
      await prefs.setBool(_welcomeShownKey, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const BarrelsListScreen();
  }
}
