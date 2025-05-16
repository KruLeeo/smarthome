import 'package:flutter/material.dart';
import 'package:testik2/core/theme/colors.dart';
import 'package:testik2/features/device/device.dart';
import 'package:testik2/screens/plug_settings.dart';
import 'package:testik2/screens/termo_settings.dart';

import 'camers_settings.dart';
import 'light_settings.dart';

class DeviceSettingsPage extends StatelessWidget {
  final Device device;

  const DeviceSettingsPage({super.key, required this.device});

  static Route route(Device device) =>
      MaterialPageRoute(builder: (_) => DeviceSettingsPage(device: device));

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkTheme ? Palete.darkBackground : Palete.lightBackground;
    final surfaceColor = isDarkTheme ? Palete.darkSurface : Palete.lightSurface;
    final textColor = isDarkTheme ? Palete.darkText : Palete.lightText;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${device.name} Settings',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: surfaceColor,
        iconTheme: IconThemeData(color: textColor),
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildSettingsForDeviceType(),
      ),
    );
  }

  Widget _buildSettingsForDeviceType() {
    switch (device.type) {
      case DeviceType.light:
        return LightSettings(device: device);
      case DeviceType.thermostat:
        return ThermostatSettings(device: device);
      case DeviceType.camera:
        return CameraSettings(device: device);
      case DeviceType.plug:
        return PlugSettings(device: device);
    }
  }
}