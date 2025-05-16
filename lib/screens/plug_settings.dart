import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testik2/core/theme/colors.dart';
import 'package:testik2/features/device/device.dart';
import 'package:testik2/screens/home_controll_bloc.dart';

class PlugSettings extends StatefulWidget {
  final Device device;

  const PlugSettings({super.key, required this.device});

  @override
  State<PlugSettings> createState() => _PlugSettingsState();
}

class _PlugSettingsState extends State<PlugSettings> {
  late bool _isOn;
  late bool _energyMonitoring;
  late String _schedule;

  @override
  void initState() {
    super.initState();
    _isOn = widget.device.isOn;
    _energyMonitoring = widget.device.settings['energyMonitoring'] ?? false;
    _schedule = widget.device.settings['schedule'] ?? 'none';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkTheme ? Palete.darkBackground : Palete.lightBackground;
    final surfaceColor = isDarkTheme ? Palete.darkSurface : Palete.lightSurface;
    final textColor = isDarkTheme ? Palete.darkText : Palete.lightText;
    final disabledColor = isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400;
    final borderColor = isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header with plug visualization
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
                    // Plug icon with status
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
                                  ? Palete.primary.withOpacity(0.3)
                                  : disabledColor.withOpacity(0.3),
                              width: 8,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.power,
                              size: 60,
                              color: _isOn ? Palete.primary : disabledColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isOn ? 'ВКЛЮЧЕНА' : 'ВЫКЛЮЧЕНА',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _isOn ? Palete.primary : disabledColor,
                              ),
                            ),
                            if (_isOn && _schedule != 'none')
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  _getScheduleText(_schedule),
                                  style: TextStyle(
                                    color: disabledColor,
                                  ),
                                  textAlign: TextAlign.center,
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
                        _isOn ? 'Розетка включена' : 'Розетка выключена',
                        style: TextStyle(color: textColor.withOpacity(0.7)),
                      ),
                      value: _isOn,
                      activeColor: Palete.primary,
                      secondary: Icon(
                        _isOn ? Icons.power : Icons.power_off,
                        color: _isOn ? Palete.primary : disabledColor,
                      ),
                      onChanged: _toggleDeviceState,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Energy monitoring
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
                    SwitchListTile(
                      title: Text(
                        'Мониторинг энергии',
                        style: TextStyle(fontSize: 16, color: textColor),
                      ),
                      subtitle: Text(
                        'Отслеживание потребления электроэнергии',
                        style: TextStyle(color: textColor.withOpacity(0.7)),
                      ),
                      value: _energyMonitoring,
                      activeColor: Palete.primary,
                      secondary: Icon(
                        Icons.bolt,
                        color: _energyMonitoring ? Palete.primary : disabledColor,
                      ),
                      onChanged: (value) {
                        setState(() => _energyMonitoring = value);
                        _sendDeviceUpdate();
                      },
                    ),
                    if (_energyMonitoring) ...[
                      const SizedBox(height: 10),
                      _buildEnergyStats(isDarkTheme, textColor),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Schedule settings
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
                      'Расписание',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ScheduleOption(
                          label: 'Нет',
                          isActive: _schedule == 'none',
                          onPressed: () => _setSchedule('none'),
                          isDarkTheme: isDarkTheme,
                        ),
                        _ScheduleOption(
                          label: 'Утро',
                          isActive: _schedule == 'morning',
                          onPressed: () => _setSchedule('morning'),
                          isDarkTheme: isDarkTheme,
                        ),
                        _ScheduleOption(
                          label: 'День',
                          isActive: _schedule == 'day',
                          onPressed: () => _setSchedule('day'),
                          isDarkTheme: isDarkTheme,
                        ),
                        _ScheduleOption(
                          label: 'Вечер',
                          isActive: _schedule == 'evening',
                          onPressed: () => _setSchedule('evening'),
                          isDarkTheme: isDarkTheme,
                        ),
                        _ScheduleOption(
                          label: 'Ночь',
                          isActive: _schedule == 'night',
                          onPressed: () => _setSchedule('night'),
                          isDarkTheme: isDarkTheme,
                        ),
                        _ScheduleOption(
                          label: 'Кастомное',
                          isActive: _schedule == 'custom',
                          onPressed: () => _showCustomScheduleDialog(context),
                          isDarkTheme: isDarkTheme,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnergyStats(bool isDarkTheme, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkTheme ? Colors.grey.shade800 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _buildStatItem('Сегодня', '2.5 кВт·ч', textColor),
          ),
          Expanded(
            child: _buildStatItem('Вчера', '3.1 кВт·ч', textColor),
          ),
          Expanded(
            child: _buildStatItem('Месяц', '45 кВт·ч', textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color textColor) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: textColor.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getScheduleText(String schedule) {
    switch (schedule) {
      case 'morning': return 'Расписание: Утро (6:00-9:00)';
      case 'day': return 'Расписание: День (9:00-18:00)';
      case 'evening': return 'Расписание: Вечер (18:00-23:00)';
      case 'night': return 'Расписание: Ночь (23:00-6:00)';
      case 'custom': return 'Кастомное расписание';
      default: return '';
    }
  }

  void _setSchedule(String schedule) {
    setState(() => _schedule = schedule);
    _sendDeviceUpdate();
  }

  void _showCustomScheduleDialog(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkTheme ? Palete.darkText : Palete.lightText;
    final backgroundColor = isDarkTheme ? Palete.darkSurface : Palete.lightSurface;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        title: Text(
          'Кастомное расписание',
          style: TextStyle(color: textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Настройте ваше расписание',
              style: TextStyle(color: textColor.withOpacity(0.7)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ОТМЕНА',
              style: TextStyle(color: textColor),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Palete.primary,
            ),
            onPressed: () {
              setState(() => _schedule = 'custom');
              _sendDeviceUpdate();
              Navigator.pop(context);
            },
            child: const Text(
              'СОХРАНИТЬ',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleDeviceState(bool newState) {
    setState(() => _isOn = newState);
    context.read<HomeControlBloc>().add(ToggleDevice(widget.device.id));
  }

  void _sendDeviceUpdate() {
    final updatedDevice = widget.device.copyWith(
      isOn: _isOn,
      settings: {
        ...widget.device.settings,
        'energyMonitoring': _energyMonitoring,
        'schedule': _schedule,
      },
    );

    context.read<HomeControlBloc>().add(UpdateDevice(updatedDevice));
  }
}

class _ScheduleOption extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onPressed;
  final bool isDarkTheme;

  const _ScheduleOption({
    required this.label,
    required this.isActive,
    required this.onPressed,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkTheme ? Palete.darkText : Palete.lightText;
    final backgroundColor = isDarkTheme ? Palete.darkSurface : Palete.lightSurface;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isActive ? Palete.primary : textColor,
        ),
      ),
      selected: isActive,
      onSelected: (selected) => onPressed(),
      selectedColor: Palete.primary.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isActive ? Palete.primary : (isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400),
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }
}