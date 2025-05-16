import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testik2/core/theme/colors.dart';
import 'package:testik2/features/device/device.dart';
import 'package:testik2/screens/home_controll_bloc.dart';

class CameraSettings extends StatefulWidget {
  final Device device;

  const CameraSettings({super.key, required this.device});

  @override
  State<CameraSettings> createState() => _CameraSettingsState();
}

class _CameraSettingsState extends State<CameraSettings> {
  late bool _isOn;
  late bool _motionDetection;
  late bool _nightVision;
  late bool _soundDetection;

  @override
  void initState() {
    super.initState();
    _isOn = widget.device.isOn;
    _motionDetection = widget.device.settings['motionDetection'] ?? false;
    _nightVision = widget.device.settings['nightVision'] ?? false;
    _soundDetection = widget.device.settings['soundDetection'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkTheme ? Palete.darkSurface : Palete.lightSurface;
    final cardColor = isDarkTheme ? Palete.darkBackground : Palete.lightBackground;
    final textColor = isDarkTheme ? Palete.darkText : Palete.lightText;
    final disabledColor = isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade400;
    final inactiveIconColor = isDarkTheme ? Colors.grey.shade500 : Colors.grey.shade600;

    return Column(
      children: [
        // Camera preview header
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: isDarkTheme ? Colors.grey.shade800 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade300,
            ),
            image: _isOn
                ? const DecorationImage(
              image: NetworkImage('https://example.com/camera-feed.jpg'),
              fit: BoxFit.cover,
            )
                : null,
          ),
          child: Stack(
            children: [
              if (!_isOn)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.videocam_off,
                        size: 50,
                        color: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Камера выключена',
                        style: TextStyle(
                          color: isDarkTheme ? Colors.grey.shade300 : Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Row(
                  children: [
                    if (_nightVision)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.nightlight_round, size: 16, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(
                              'Ночной режим',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Main controls
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade300,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkTheme ? 0.3 : 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              // Power switch
              _buildControlCard(
                icon: Icons.power_settings_new,
                title: 'Состояние камеры',
                value: _isOn,
                isEnabled: true,
                isDarkTheme: isDarkTheme,
                textColor: textColor,
                cardColor: cardColor,
                onChanged: (value) {
                  setState(() => _isOn = value);
                  _updateDevice();
                },
              ),
              const SizedBox(height: 16),

              // Motion detection
              _buildControlCard(
                icon: Icons.directions_run,
                title: 'Детекция движения',
                value: _motionDetection,
                isEnabled: _isOn,
                isDarkTheme: isDarkTheme,
                textColor: textColor,
                cardColor: cardColor,
                onChanged: _isOn ? (value) {
                  setState(() => _motionDetection = value);
                  _updateDevice();
                } : null,
              ),
              const SizedBox(height: 16),

              // Night vision
              _buildControlCard(
                icon: Icons.nightlight_round,
                title: 'Ночное видение',
                value: _nightVision,
                isEnabled: _isOn,
                isDarkTheme: isDarkTheme,
                textColor: textColor,
                cardColor: cardColor,
                onChanged: _isOn ? (value) {
                  setState(() => _nightVision = value);
                  _updateDevice();
                } : null,
              ),
              const SizedBox(height: 16),

              // Sound detection
              _buildControlCard(
                icon: Icons.mic,
                title: 'Детекция звука',
                value: _soundDetection,
                isEnabled: _isOn,
                isDarkTheme: isDarkTheme,
                textColor: textColor,
                cardColor: cardColor,
                onChanged: _isOn ? (value) {
                  setState(() => _soundDetection = value);
                  _updateDevice();
                } : null,
              ),
            ],
          ),
        ),

        if (!_isOn)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: Text(
                'Включите камеру для доступа к настройкам',
                style: TextStyle(
                  color: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildControlCard({
    required IconData icon,
    required String title,
    required bool value,
    required bool isEnabled,
    required bool isDarkTheme,
    required Color textColor,
    required Color cardColor,
    required ValueChanged<bool>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isEnabled ? Palete.primary : (isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade500),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isEnabled ? textColor : (isDarkTheme ? Colors.grey.shade500 : Colors.grey.shade600),
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Palete.primary,
            inactiveTrackColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade400,
          ),
        ],
      ),
    );
  }

  void _updateDevice() {
    final updatedDevice = widget.device.copyWith(
      isOn: _isOn,
      settings: {
        ...widget.device.settings,
        'motionDetection': _motionDetection,
        'nightVision': _nightVision,
        'soundDetection': _soundDetection,
      },
    );

    context.read<HomeControlBloc>().add(UpdateDevice(updatedDevice));
  }
}