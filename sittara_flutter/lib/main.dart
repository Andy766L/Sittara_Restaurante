import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // New import
import 'package:sittara_flutter/screens/splash_screen.dart';
import 'package:sittara_flutter/services/auth_service.dart';
import 'package:sittara_flutter/services/supabase_service.dart'; // New import

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);

  // Initialize Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const goldColor = Color(0xFFD4AF37); // A classic gold color
    const darkTextColor = Color(0xFF3D3D3D);
    const lightTextColor = Color(0xFF6E6E6E);
    const backgroundColor = Color(0xFFFCFCFC);
    const surfaceColor = Color(0xFFFFFFFF);

    return MaterialApp(
      title: 'Sittara',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: goldColor,
          brightness: Brightness.light,
          primary: goldColor,
          surface: backgroundColor,
        ),
        textTheme: GoogleFonts.montserratTextTheme(textTheme).copyWith(
          displayLarge: GoogleFonts.playfairDisplay(
            textStyle: textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: darkTextColor,
            ),
          ),
          displayMedium: GoogleFonts.playfairDisplay(
            textStyle: textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: darkTextColor,
            ),
          ),
          displaySmall: GoogleFonts.playfairDisplay(
            textStyle: textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: darkTextColor,
            ),
          ),
          headlineLarge: GoogleFonts.playfairDisplay(
            textStyle: textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: darkTextColor,
            ),
          ),
          headlineMedium: GoogleFonts.playfairDisplay(
            textStyle: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: darkTextColor,
            ),
          ),
          headlineSmall: GoogleFonts.playfairDisplay(
            textStyle: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: darkTextColor,
            ),
          ),
          titleLarge: GoogleFonts.montserrat(
            textStyle: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: darkTextColor,
            ),
          ),
          titleMedium: GoogleFonts.montserrat(
            textStyle: textTheme.titleMedium?.copyWith(color: lightTextColor),
          ),
          titleSmall: GoogleFonts.montserrat(
            textStyle: textTheme.titleSmall?.copyWith(color: lightTextColor),
          ),
          bodyLarge: GoogleFonts.montserrat(
            textStyle: textTheme.bodyLarge?.copyWith(
              color: lightTextColor,
              fontSize: 16,
            ),
          ),
          bodyMedium: GoogleFonts.montserrat(
            textStyle: textTheme.bodyMedium?.copyWith(color: lightTextColor),
          ),
          bodySmall: GoogleFonts.montserrat(
            textStyle: textTheme.bodySmall?.copyWith(color: lightTextColor),
          ),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: surfaceColor,
          elevation: 0,
          iconTheme: IconThemeData(color: darkTextColor),
          titleTextStyle: TextStyle(
            color: darkTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
