import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testik2/core/theme/colors.dart';
import 'package:testik2/features/device/device.dart';
import 'package:testik2/screens/home_controll_bloc.dart';

class ThermostatSettings extends StatefulWidget {
  final Device device;

  const ThermostatSettings({super.key, required this.device});

  @override
  State<ThermostatSettings> createState() => _ThermostatSettingsState();
}

class _ThermostatSettingsState extends State<ThermostatSettings> {
  late bool _isOn;
  late double _temperature;
  String _mode = 'heat'; // 'heat' or 'cool'

  @override
  void initState() {
    super.initState();
    _isOn = widget.device.isOn;
    _temperature = (widget.device.settings['temperature'] ?? 20).toDouble();
    _mode = widget.device.settings['mode'] ?? 'heat';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkTheme ? Palete.darkBackground : Palete.lightBackground;
    final surfaceColor = isDarkTheme ? Palete.darkSurface : Palete.lightSurface;
    final textColor = isDarkTheme ? Palete.darkText : Palete.lightText;
    final disabledColor = isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400;
    final borderColor = isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade300;

    return Column(
      children: [
        // Header with thermostat visualization
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkTheme ? 0.2 : 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              // Thermostat icon with temperature
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isOn
                            ? (_mode == 'heat'
                            ? Colors.orange.withOpacity(0.3)
                            : Colors.blue.withOpacity(0.3))
                            : disabledColor.withOpacity(0.3),
                        width: 8,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _mode == 'heat' ? Icons.thermostat : Icons.ac_unit,
                        size: 40,
                        color: _isOn
                            ? (_mode == 'heat' ? Colors.orange : Colors.blue)
                            : disabledColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_temperature.round()}°C',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: _isOn
                              ? (_mode == 'heat' ? Colors.orange : Colors.blue)
                              : disabledColor,
                        ),
                      ),
                      Text(
                        _mode == 'heat' ? 'Нагрев' : 'Охлаждение',
                        style: TextStyle(
                          color: _isOn
                              ? (_mode == 'heat' ? Colors.orange : Colors.blue)
                              : disabledColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Power switch
              SwitchListTile(
                title: Text(
                  'Состояние',
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
                subtitle: Text(
                  _isOn ? 'Включен' : 'Выключен',
                  style: TextStyle(color: textColor.withOpacity(0.7)),
                ),
                value: _isOn,
                activeColor: Palete.primary,
                secondary: Icon(
                  _isOn ? Icons.power_settings_new : Icons.power_off,
                  color: _isOn ? Palete.primary : disabledColor,
                ),
                onChanged: _toggleDeviceState,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Mode selection
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkTheme ? 0.2 : 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Режим работы',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ModeButton(
                    icon: Icons.whatshot,
                    label: 'Нагрев',
                    isActive: _mode == 'heat',
                    onPressed: () => _changeMode('heat'),
                    color: Colors.orange,
                    backgroundColor: surfaceColor,
                    textColor: textColor,
                    borderColor: borderColor,
                  ),
                  _ModeButton(
                    icon: Icons.ac_unit,
                    label: 'Охлаждение',
                    isActive: _mode == 'cool',
                    onPressed: () => _changeMode('cool'),
                    color: Colors.blue,
                    backgroundColor: surfaceColor,
                    textColor: textColor,
                    borderColor: borderColor,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Temperature control
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkTheme ? 0.2 : 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Температура',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
              const SizedBox(height: 10),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: _mode == 'heat' ? Colors.orange : Colors.blue,
                  inactiveTrackColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade300,
                  thumbColor: _mode == 'heat' ? Colors.orange : Colors.blue,
                  overlayColor: _mode == 'heat'
                      ? Colors.orange.withOpacity(0.2)
                      : Colors.blue.withOpacity(0.2),
                  valueIndicatorColor: _mode == 'heat' ? Colors.orange : Colors.blue,
                  showValueIndicator: ShowValueIndicator.always,
                ),
                child: Slider(
                  value: _temperature,
                  min: 10,
                  max: 30,
                  divisions: 20,
                  label: '${_temperature.round()}°C',
                  onChanged: _isOn ? _updateTemperature : null,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('10°C', style: TextStyle(color: textColor.withOpacity(0.7))),
                  Text('30°C', style: TextStyle(color: textColor.withOpacity(0.7))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Quick adjust buttons
        if (_isOn) ...[
          Row(
            children: [
              Expanded(
                child: _QuickTempButton(
                  temperature: 18,
                  label: 'Прохладно',
                  onPressed: () => _setTemperature(18),
                  isActive: _temperature == 18,
                  isDarkTheme: isDarkTheme,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickTempButton(
                  temperature: 22,
                  label: 'Комфортно',
                  onPressed: () => _setTemperature(22),
                  isActive: _temperature == 22,
                  isDarkTheme: isDarkTheme,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickTempButton(
                  temperature: 26,
                  label: 'Тепло',
                  onPressed: () => _setTemperature(26),
                  isActive: _temperature == 26,
                  isDarkTheme: isDarkTheme,
                ),
              ),
            ],
          ),
        ],

        if (!_isOn)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: Text(
                'Включите термостат для регулировки',
                style: TextStyle(
                  color: disabledColor,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _changeMode(String newMode) {
    setState(() => _mode = newMode);
    _sendDeviceUpdate();
  }

  void _setTemperature(double temp) {
    setState(() => _temperature = temp);
    _sendDeviceUpdate();
  }

  void _toggleDeviceState(bool newState) {
    setState(() => _isOn = newState);
    context.read<HomeControlBloc>().add(ToggleDevice(widget.device.id));
  }

  void _updateTemperature(double newTemp) {
    setState(() => _temperature = newTemp);
    _sendDeviceUpdate();
  }

  void _sendDeviceUpdate() {
    final updatedDevice = widget.device.copyWith(
      isOn: _isOn,
      settings: {
        ...widget.device.settings,
        'temperature': _temperature,
        'mode': _mode,
      },
    );

    context.read<HomeControlBloc>().add(UpdateDevice(updatedDevice));
  }
}

class _ModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;
  final Color color;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const _ModeButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onPressed,
    required this.color,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: isActive ? color : textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isActive ? color : borderColor,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: isActive ? color : textColor)),
        ],
      ),
    );
  }
}

class _QuickTempButton extends StatelessWidget {
  final double temperature;
  final String label;
  final VoidCallback onPressed;
  final bool isActive;
  final bool isDarkTheme;

  const _QuickTempButton({
    required this.temperature,
    required this.label,
    required this.onPressed,
    required this.isActive,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkTheme ? Palete.darkText : Palete.lightText;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: isActive
            ? Palete.primary.withOpacity(0.1)
            : Colors.transparent,
        foregroundColor: isActive ? Palete.primary : textColor,
        side: BorderSide(
          color: isActive ? Palete.primary : (isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: onPressed,
      child: Column(
        children: [
          Text(
            '$temperature°C',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? Palete.primary : textColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Palete.primary : textColor,
            ),
          ),
        ],
      ),
    );
  }
}