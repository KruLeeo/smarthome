// features/device/bloc/devices_state.dart
// part of 'devices_bloc.dart';

import '../device.dart';

abstract class DevicesState {
  const DevicesState();
}

class DevicesLoadingState extends DevicesState {}

class DevicesLoadedState extends DevicesState {
  final List<Device> devices;
  const DevicesLoadedState(this.devices);
}

class DevicesErrorState extends DevicesState {
  final String message;
  const DevicesErrorState(this.message);
}