import 'package:financial_management_app/views/authentication/login_view.dart';
import 'package:financial_management_app/views/authentication/register_view.dart';
import 'package:financial_management_app/views/calendar/calendar_view.dart';
import 'package:financial_management_app/views/graph/graph_view.dart';
import 'package:financial_management_app/views/home/home_view.dart';
import 'package:financial_management_app/views/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: '/login',
      defaultTransition: Transition.noTransition,
      routes: {
        '/login': (context) => LoginView(),
        '/register': (context) => RegisterView(),
        '/home': (context) => const HomeView(),
        '/calendar': (context) => const CalendarView(),
        '/graph': (context) => const GraphView(),
        '/settings': (context) => const SettingsView(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
    );
  }
}
