import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:testik2/screens/dashboard_page.dart';
import 'package:testik2/screens/home_controll_bloc.dart';

import 'core/theme/theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/device/bloc/devices_bloc.dart';
import 'features/scenes/bloc/scenes_bloc.dart';
import 'init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Добавляем ThemeProvider
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<HomeControlBloc>()),
        BlocProvider(create: (_) => serviceLocator<DevicesBloc>()),
        BlocProvider(create: (_) => serviceLocator<ScenesBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Home',
      theme: AppTheme.lightTheme, // Светлая тема
      darkTheme: AppTheme.darkTheme, // Темная тема
      themeMode: themeProvider.themeMode, // Используем текущий режим из ThemeProvider
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
      onGenerateRoute: (settings) {
        // Handle other routes here
        return null;
      },
    );
  }
}