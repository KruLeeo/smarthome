// home_controll_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/device/device.dart';

abstract class HomeControlEvent {}

class LoadHomeDevices extends HomeControlEvent {}

class FilterByRoom extends HomeControlEvent {
  final String? room;
  FilterByRoom(this.room);
}
class AddDevice extends HomeControlEvent {
  final Device device;
  AddDevice(this.device);
}

class UpdateDevice extends HomeControlEvent {
  final Device device;
  UpdateDevice(this.device);
}

class ToggleDevice extends HomeControlEvent {
  final String deviceId;
  ToggleDevice(this.deviceId);
}

abstract class HomeControlState {}

class HomeControlLoading extends HomeControlState {}

class HomeControlLoaded extends HomeControlState {
  final List<Device> devices;
  final String? selectedRoom;

  HomeControlLoaded(this.devices, {this.selectedRoom});

  HomeControlLoaded copyWith({
    List<Device>? devices,
    String? selectedRoom,
  }) {
    return HomeControlLoaded(
      devices ?? this.devices,
      selectedRoom: selectedRoom ?? this.selectedRoom,
    );
  }
}

class HomeControlError extends HomeControlState {
  final String message;
  HomeControlError(this.message);
}

class HomeControlBloc extends Bloc<HomeControlEvent, HomeControlState> {
  HomeControlBloc() : super(HomeControlLoading()) {
    on<LoadHomeDevices>((event, emit) async {
      emit(HomeControlLoading());
      try {
        // Здесь должна быть логика загрузки устройств из Supabase
        await Future.delayed(const Duration(seconds: 1));
        emit(HomeControlLoaded(_demoDevices));
      } catch (e) {
        emit(HomeControlError(e.toString()));
      }
    });
    on<AddDevice>((event, emit) {
      if (state is HomeControlLoaded) {
        final currentState = state as HomeControlLoaded;
        emit(HomeControlLoaded([...currentState.devices, event.device], selectedRoom: currentState.selectedRoom));
      }
    });

    on<FilterByRoom>((event, emit) {
      if (state is HomeControlLoaded) {
        final currentState = state as HomeControlLoaded;
        emit(currentState.copyWith(selectedRoom: event.room));
      }
    });


    on<ToggleDevice>((event, emit) {
      if (state is HomeControlLoaded) {
        final currentState = state as HomeControlLoaded;
        final updatedDevices = currentState.devices.map((device) {
          return device.id == event.deviceId
              ? device.copyWith(isOn: !device.isOn)
              : device;
        }).toList();
        emit(currentState.copyWith(devices: updatedDevices));
      }
    });
  }

  final List<Device> _demoDevices = [
    Device(
      id: '1',
      name: 'Living Light',
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
    Device(
      id: '4',
      name: 'Plug',
      type: DeviceType.plug,
      room: 'Entrance',
      isOn: true,
    ),
  ];
}