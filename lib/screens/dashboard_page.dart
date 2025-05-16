import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:testik2/screens/room_selector.dart';
import 'package:testik2/features/scenes/scenes_page.dart';
import 'package:testik2/screens/setting_page.dart';
import 'package:testik2/screens/settings_page.dart';

import '../core/theme/app_icons.dart';
import '../core/theme/colors.dart';
import '../core/theme/theme_provider.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/device/device_card.dart';
import '../features/device/devices_page.dart';
import 'home_controll_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  static Route route() => MaterialPageRoute(builder: (_) => const DashboardPage());

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeControlBloc>().add(LoadHomeDevices());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkTheme ? Palete.darkBackground : Palete.lightBackground;
    final appBarColor = isDarkTheme ? Palete.darkSurface : Palete.lightSurface;
    final iconColor = isDarkTheme ? Palete.darkText : Palete.lightText;
    final textColor = isDarkTheme ? Palete.darkText : Palete.lightText;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Smart Home',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: iconColor),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
                activeColor: Palete.primary,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: iconColor),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogout());
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeControlBloc, HomeControlState>(
        builder: (context, state) {
          if (state is HomeControlLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Palete.primary,
              ),
            );
          }

          if (state is! HomeControlLoaded) {
            return Center(
              child: Text(
                'Error loading devices',
                style: TextStyle(color: textColor),
              ),
            );
          }

          final devices = state.selectedRoom == null || state.selectedRoom == 'All Rooms'
              ? state.devices
              : state.devices.where((d) => d.room == state.selectedRoom).toList();

          return Column(
            children: [
              const RoomSelector(),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    final device = devices[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, DeviceSettingsPage.route(device));
                      },
                      child: DeviceCard(device: device),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: backgroundColor,
        selectedItemColor: Palete.primary,
        unselectedItemColor: isDarkTheme ? Palete.darkText.withOpacity(0.6) : Palete.lightText.withOpacity(0.6),
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(AppIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.devices),
            label: 'Devices',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.scenes),
            label: 'Scenes',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(context, DevicesPage.route());
              break;
            case 2:
              Navigator.push(context, ScenesPage.route());
              break;
            case 3:
              Navigator.push(context, SettingsPage.route());
              break;
          }
        },
      ),
    );
  }
}