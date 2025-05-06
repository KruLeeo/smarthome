// features/device/bloc/devices_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testik2/features/device/device.dart';

import 'devices_event.dart';
import 'devices_state.dart';

class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  DevicesBloc() : super(DevicesLoadingState()) {
    on<LoadDevicesEvent>((event, emit) async {
      emit(DevicesLoadingState());
      try {
        await Future.delayed(const Duration(seconds: 1));
        emit(DevicesLoadedState(_demoDevices));
      } catch (e) {
        emit(DevicesErrorState('Failed to load devices'));
      }
    });

    on<AddDeviceEvent>((event, emit) {
      if (state is DevicesLoadedState) {
        final currentState = state as DevicesLoadedState;
        emit(DevicesLoadedState([...currentState.devices, event.device]));
      }
    });

    on<UpdateDeviceEvent>((event, emit) {
      if (state is DevicesLoadedState) {
        final currentState = state as DevicesLoadedState;
        final updatedDevices = currentState.devices.map((device) {
          return device.id == event.device.id ? event.device : device;
        }).toList();
        emit(DevicesLoadedState(updatedDevices));
      }
    });

    on<DeleteDeviceEvent>((event, emit) {
      if (state is DevicesLoadedState) {
        final currentState = state as DevicesLoadedState;
        final updatedDevices = currentState.devices
            .where((device) => device.id != event.deviceId)
            .toList();
        emit(DevicesLoadedState(updatedDevices));
      }
    });

    on<ToggleDeviceEvent>((event, emit) {
      if (state is DevicesLoadedState) {
        final currentState = state as DevicesLoadedState;
        final updatedDevices = currentState.devices.map((device) {
          return device.id == event.deviceId
              ? device.copyWith(isOn: !device.isOn)
              : device;
        }).toList();
        emit(DevicesLoadedState(updatedDevices));
      }
    });
  }

  final List<Device> _demoDevices = [
    Device(
      id: '1',
      name: 'Living Room Light',
      type: DeviceType.light,
      room: 'Living Room',
      isOn: true,
      settings: {'brightness': 80},
    ),
    Device(
      id: '2',
      name: 'Thermostat',
      type: DeviceType.thermostat,
      room: 'Living Room',
      isOn: true,
      settings: {'temperature': 22},
    ),
    Device(
      id: '3',
      name: 'Security Camera',
      type: DeviceType.camera,
      room: 'Entrance',
      isOn: true,
    ),
  ];
}