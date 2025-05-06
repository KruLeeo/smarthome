import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testik2/core/theme/colors.dart';
import 'package:testik2/features/device/device.dart';
import 'package:testik2/features/device/bloc/devices_bloc.dart';
import 'package:testik2/features/device/bloc/devices_event.dart';

class DeviceListItem extends StatelessWidget {
  final Device device;

  const DeviceListItem({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        _getDeviceIcon(device.type),
        color: device.isOn ? Palete.primary : Palete.lightText,
      ),
      title: Text(
        device.name,
        style: TextStyle(
          color: device.isOn ? Colors.white : Palete.lightText,
        ),
      ),
      subtitle: Text(
        device.room,
        style: TextStyle(
          color: device.isOn ? Colors.white70 : Palete.lightText.withOpacity(0.7),
        ),
      ),
      trailing: Switch(
        value: device.isOn,
        onChanged: (value) {
          context.read<DevicesBloc>().add(ToggleDeviceEvent(device.id));
        },
        activeColor: Palete.primary,
      ),
    );
  }

  IconData _getDeviceIcon(DeviceType type) {
    switch (type) {
      case DeviceType.light:
        return Icons.lightbulb_outline;
      case DeviceType.thermostat:
        return Icons.thermostat;
      case DeviceType.camera:
        return Icons.videocam;
      default:
        return Icons.device_unknown;
    }
  }
}