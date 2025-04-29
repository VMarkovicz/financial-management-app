import 'package:financial_management_app/repositories/transactions_repository.dart';
import 'package:financial_management_app/repositories/user_repository.dart';
import 'package:financial_management_app/services/api_service.dart';
import 'package:financial_management_app/viewmodels/transactions_viewmodel.dart';
import 'package:financial_management_app/viewmodels/user_viewmodel.dart';
import 'package:financial_management_app/views/authentication/login_view.dart';
import 'package:financial_management_app/views/authentication/register_view.dart';
import 'package:financial_management_app/views/calendar/calendar_view.dart';
import 'package:financial_management_app/views/graph/graph_view.dart';
import 'package:financial_management_app/views/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:financial_management_app/views/home/home_view.dart';
import 'package:financial_management_app/theme/app_theme.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  late final ApiService apiService;
  late final UserRepository userRepository;
  late final TransactionsRepository transactionsRepository;

  App({super.key}) {
    apiService = ApiService();
    userRepository = UserRepository(apiService);
    transactionsRepository = TransactionsRepository(apiService);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel(userRepository)),
        ChangeNotifierProvider(
          create: (_) => TransactionsViewmodel(transactionsRepository),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Financial Management App',
        home: const HomeView(),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginView(),
          '/register': (context) => RegisterView(),
          '/home': (context) => const HomeView(),
          '/calendar': (context) => const CalendarView(),
          '/graph': (context) => const GraphView(),
          '/settings': (context) => const SettingsView(),
        },
        theme: AppTheme.theme.copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            },
          ),
        ),
      ),
    );
  }
}
