// features/device/device.dart
enum DeviceType { light, thermostat, camera, plug }

class Device {
  final String id;
  final String name;
  final DeviceType type;
  final String room;
  final bool isOn;
  final Map<String, dynamic> settings;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.room,
    this.isOn = false,
    this.settings = const {},
  });

  Device copyWith({
    String? id,
    String? name,
    DeviceType? type,
    String? room,
    bool? isOn,
    Map<String, dynamic>? settings,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      room: room ?? this.room,
      isOn: isOn ?? this.isOn,
      settings: settings ?? this.settings,
    );
  }
}