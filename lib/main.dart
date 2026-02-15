import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moshir_ui/ui/providers/settings_provider.dart';
import 'package:moshir_ui/ui/splash/splash_screen.dart';
import 'package:moshir_ui/ui/components/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<ThemeNotifier>(
      context,
    ).themeMode; // دریافت وضعیت تم

    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('fa'), // Farsi
        // Locale('en'), // English
        // Locale('es'), // Spanish
      ],
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Vazirmatn',
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white, // پس‌زمینه برای تم روشن
          selectedItemColor: Colors.blue, // رنگ آیکون انتخاب شده
          unselectedItemColor: Colors.grey, // رنگ آیکون‌های انتخاب نشده
        ),
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 134, 144, 162),
          ),
          bodySmall: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 56, 61, 72),
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(255, 56, 61, 72),
          ),
          labelMedium: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 100,
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(255, 56, 61, 72),
          ),
          labelSmall: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 56, 61, 72),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Vazirmatn',
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: Colors.black,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
        ),
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // صفحه تنظیمات به عنوان صفحه اصلی
    );
  }

  String getTime() {
    DateTime now = DateTime.now();
    return DateFormat('kk:mm:ss').format(now);
  }

  String getDate() {
    DateTime now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }
}
