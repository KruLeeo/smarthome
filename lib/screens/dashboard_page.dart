// dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testik2/screens/room_selector.dart';
import 'package:testik2/features/scenes/scenes_page.dart';
import 'package:testik2/screens/setting_page.dart';
import 'package:testik2/screens/settings_page.dart';

import '../core/theme/app_icons.dart';
import '../core/theme/colors.dart';
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
    return Scaffold(
      backgroundColor: Palete.darkBackground,
      appBar: AppBar(
        title: const Text(
          'Smart Home',
          style: TextStyle(color: Colors.black), // Черный цвет текста
        ),
        backgroundColor: Colors.white, // Белый фон AppBar для контраста
        iconTheme: IconThemeData(color: Colors.black), // Черные иконки (например, кнопка назад)
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black), // Черная иконка выхода
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
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! HomeControlLoaded) {
            return const Center(child: Text('Error loading devices'));
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
        backgroundColor: Palete.darkBackground, // Белый фон
        selectedItemColor: Palete.primary, // Цвет выбранной иконки (зеленый)
        unselectedItemColor: Colors.black, // Черный цвет для невыбранных иконок
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(AppIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(AppIcons.devices), label: 'Devices'),
          BottomNavigationBarItem(icon: Icon(AppIcons.scenes), label: 'Scenes'),
          BottomNavigationBarItem(icon: Icon(AppIcons.settings), label: 'Settings'),
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