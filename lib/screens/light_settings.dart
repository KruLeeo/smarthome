import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testik2/core/theme/colors.dart';
import 'package:testik2/features/device/device.dart';
import 'package:testik2/screens/home_controll_bloc.dart';

class LightSettings extends StatefulWidget {
  final Device device;

  const LightSettings({super.key, required this.device});

  @override
  State<LightSettings> createState() => _LightSettingsState();
}

class _LightSettingsState extends State<LightSettings> {
  late bool _isOn;
  late double _brightness;
  Color _selectedColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _isOn = widget.device.isOn;
    _brightness = (widget.device.settings['brightness'] ?? 50).toDouble();
    _selectedColor = _parseColor(widget.device.settings['color'] ?? '#FFFFFF');
  }

  Color _parseColor(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    return Color(int.parse("0xFF$hexColor"));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with light icon
        Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (_isOn)
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _selectedColor.withOpacity(_brightness / 200),
                        boxShadow: [
                          BoxShadow(
                            color: _selectedColor.withOpacity(_brightness / 150),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  Icon(
                    Icons.lightbulb,
                    size: 60,
                    color: _isOn
                        ? _selectedColor.withOpacity(0.9)
                        : Colors.grey[400],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${_brightness.round()}%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _isOn ? Palete.primary : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Power switch
        SwitchListTile(
          title: const Text('Состояние', style: TextStyle(fontSize: 16)),
          subtitle: Text(_isOn ? 'Включено' : 'Выключено'),
          value: _isOn,
          activeColor: Palete.primary,
          secondary: Icon(
            _isOn ? Icons.power_settings_new : Icons.power_off,
            color: _isOn ? Palete.primary : Colors.grey,
          ),
          onChanged: (value) {
            setState(() => _isOn = value);
            _updateDevice();
          },
        ),
        const Divider(height: 30),

        // Brightness control
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Яркость', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.brightness_low, color: Colors.grey[600]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Slider(
                      value: _brightness,
                      min: 0,
                      max: 100,
                      divisions: 10,
                      label: '${_brightness.round()}%',
                      onChanged: _isOn ? (value) {
                        setState(() => _brightness = value);
                        _updateDevice();
                      } : null,
                      activeColor: Palete.primary,
                      inactiveColor: Colors.grey[300],
                    ),
                  ),
                  Icon(Icons.brightness_high, color: Colors.grey[600]),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 30),

        // Color selection
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Цвет света', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _ColorOption(
                    color: Colors.white,
                    isSelected: _selectedColor.value == Colors.white.value,
                    onTap: () => _changeColor(Colors.white),
                  ),
                  _ColorOption(
                    color: Colors.yellow[200]!,
                    isSelected: _selectedColor.value == Colors.yellow[200]!.value,
                    onTap: () => _changeColor(Colors.yellow[200]!),
                  ),
                  _ColorOption(
                    color: Colors.orange[200]!,
                    isSelected: _selectedColor.value == Colors.orange[200]!.value,
                    onTap: () => _changeColor(Colors.orange[200]!),
                  ),
                  _ColorOption(
                    color: Colors.red[200]!,
                    isSelected: _selectedColor.value == Colors.red[200]!.value,
                    onTap: () => _changeColor(Colors.red[200]!),
                  ),
                  _ColorOption(
                    color: Colors.blue[200]!,
                    isSelected: _selectedColor.value == Colors.blue[200]!.value,
                    onTap: () => _changeColor(Colors.blue[200]!),
                  ),
                  _ColorOption(
                    color: Colors.green[200]!,
                    isSelected: _selectedColor.value == Colors.green[200]!.value,
                    onTap: () => _changeColor(Colors.green[200]!),
                  ),
                ],
              ),
            ],
          ),
        ),

        if (!_isOn)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: Text(
                'Включите свет для регулировки',
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

  void _changeColor(Color newColor) {
    setState(() {
      _selectedColor = newColor;
    });
    _updateDevice();
  }

  void _updateDevice() {
    final updatedDevice = widget.device.copyWith(
      isOn: _isOn,
      settings: {
        ...widget.device.settings,
        'brightness': _brightness,
        'color': '#${_selectedColor.value.toRadixString(16).substring(2)}',
      },
    );

    context.read<HomeControlBloc>().add(UpdateDevice(updatedDevice));
  }
}

class _ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;

  const _ColorOption({
    required this.color,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: Palete.primary, width: 3)
              : Border.all(color: Colors.grey[300]!, width: 1),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 2,
              ),
          ],
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : null,
      ),
    );
  }
}