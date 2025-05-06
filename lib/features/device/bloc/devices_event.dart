// features/device/bloc/devices_event.dart
import '../device.dart';
// part of 'devices_bloc.dart';

abstract class DevicesEvent {
  const DevicesEvent();
}

class LoadDevicesEvent extends DevicesEvent {}

class AddDeviceEvent extends DevicesEvent {
  final Device device;
  const AddDeviceEvent(this.device);
}

class UpdateDeviceEvent extends DevicesEvent {
  final Device device;
  const UpdateDeviceEvent(this.device);
}

class DeleteDeviceEvent extends DevicesEvent {
  final String deviceId;
  const DeleteDeviceEvent(this.deviceId);
}

class ToggleDeviceEvent extends DevicesEvent {
  final String deviceId;
  const ToggleDeviceEvent(this.deviceId);
}