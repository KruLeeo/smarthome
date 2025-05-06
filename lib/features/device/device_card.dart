// features/device/device_card.dart
import 'package:flutter/material.dart';
import 'package:testik2/core/theme/app_icons.dart';
import 'package:testik2/core/theme/colors.dart';
import 'package:testik2/features/device/device.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Function(double)? onBrightnessChanged;

  const DeviceCard({
    super.key,
    required this.device,
    this.onTap,
    this.onLongPress,
    this.onBrightnessChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: device.isOn ? Palete.primary.withOpacity(0.2) : Palete.darkSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: device.isOn ? Palete.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    _getDeviceIcon(device.type),
                    size: 32,
                    color: device.isOn ? Palete.primary : Palete.lightText,
                  ),
                  _buildStatusIndicator(),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                device.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: device.isOn ? Colors.white : Palete.lightText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                device.room,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: device.isOn ? Colors.white70 : Palete.lightText.withOpacity(0.7),
                ),
              ),
              const Spacer(),
              _buildDeviceSpecificControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: device.isOn ? Colors.green : Colors.grey,
        border: Border.all(color: Colors.white24, width: 2),
      ),
    );
  }

  Widget _buildDeviceSpecificControls() {
    switch (device.type) {
      case DeviceType.light:
        return Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.brightness_4,
                  color: device.isOn ? Palete.primary : Palete.lightText.withOpacity(0.5),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Slider(
                    value: (device.settings['brightness'] ?? 50).toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: '${(device.settings['brightness'] ?? 50).toInt()}%',
                    onChanged: device.isOn
                        ? (value) {
                      if (onBrightnessChanged != null) {
                        onBrightnessChanged!(value);
                      }
                    }
                        : null,
                    activeColor: Palete.primary,
                    inactiveColor: Palete.lightText.withOpacity(0.3),
                  ),
                ),
                Text(
                  '${(device.settings['brightness'] ?? 50).toInt()}%',
                  style: TextStyle(
                    color: device.isOn ? Palete.primary : Palete.lightText.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (!device.isOn)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Включите устройство для настройки',
                  style: TextStyle(
                    color: Palete.lightText.withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        );
      case DeviceType.thermostat:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Температура',
              style: TextStyle(
                color: device.isOn ? Colors.white70 : Palete.lightText.withOpacity(0.7),
              ),
            ),
            Text(
              '${device.settings['temperature'] ?? 20}°C',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: device.isOn ? Palete.primary : Palete.lightText,
              ),
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  IconData _getDeviceIcon(DeviceType type) {
    switch (type) {
      case DeviceType.light:
        return AppIcons.light;
      case DeviceType.thermostat:
        return AppIcons.thermostat;
      case DeviceType.camera:
        return AppIcons.camera;
      case DeviceType.plug:
        return AppIcons.plug;
    }
  }
}