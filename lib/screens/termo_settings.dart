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
    return Column(
      children: [
        // Header with thermostat visualization
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Palete.darkSurface,
            borderRadius: BorderRadius.circular(16),
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
                            : Colors.grey.withOpacity(0.3),
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
                            : Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_temperature.round()}°C',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: _isOn ? Colors.white : Colors.grey,
                        ),
                      ),
                      Text(
                        _mode == 'heat' ? 'Нагрев' : 'Охлаждение',
                        style: TextStyle(
                          color: _isOn
                              ? (_mode == 'heat' ? Colors.orange : Colors.blue)
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Power switch
              SwitchListTile(
                title: const Text('Состояние', style: TextStyle(fontSize: 16)),
                subtitle: Text(_isOn ? 'Включен' : 'Выключен'),
                value: _isOn,
                activeColor: Palete.primary,
                secondary: Icon(
                  _isOn ? Icons.power_settings_new : Icons.power_off,
                  color: _isOn ? Palete.primary : Colors.grey,
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
            color: Palete.darkSurface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Режим работы', style: TextStyle(fontSize: 16)),
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
                  ),
                  _ModeButton(
                    icon: Icons.ac_unit,
                    label: 'Охлаждение',
                    isActive: _mode == 'cool',
                    onPressed: () => _changeMode('cool'),
                    color: Colors.blue,
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
            color: Palete.darkSurface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Температура', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: _mode == 'heat' ? Colors.orange : Colors.blue,
                  inactiveTrackColor: Colors.grey[300],
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
                  Text('10°C', style: TextStyle(color: Colors.grey[600])),
                  Text('30°C', style: TextStyle(color: Colors.grey[600])),
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
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickTempButton(
                  temperature: 22,
                  label: 'Комфортно',
                  onPressed: () => _setTemperature(22),
                  isActive: _temperature == 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickTempButton(
                  temperature: 26,
                  label: 'Тепло',
                  onPressed: () => _setTemperature(26),
                  isActive: _temperature == 26,
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
                  color: Colors.grey[600],
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

  const _ModeButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? color.withOpacity(0.2) : Colors.transparent,
        foregroundColor: isActive ? color : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isActive ? color : Colors.grey.withOpacity(0.5),
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
          Text(label),
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

  const _QuickTempButton({
    required this.temperature,
    required this.label,
    required this.onPressed,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: isActive
            ? Palete.primary.withOpacity(0.1)
            : Colors.transparent,
        foregroundColor: isActive ? Palete.primary : Colors.grey,
        side: BorderSide(
          color: isActive ? Palete.primary : Colors.grey.withOpacity(0.3),
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}