import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/device/device.dart';

// События
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

class DeleteDevice extends HomeControlEvent {
  final String deviceId;
  DeleteDevice(this.deviceId);
}

class ToggleDevice extends HomeControlEvent {
  final String deviceId;
  ToggleDevice(this.deviceId);
}

// Состояния
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

// Блок
class HomeControlBloc extends Bloc<HomeControlEvent, HomeControlState> {
  HomeControlBloc() : super(HomeControlLoading()) {
    on<LoadHomeDevices>(_onLoadDevices);
    on<AddDevice>(_onAddDevice);
    on<UpdateDevice>(_onUpdateDevice);
    on<DeleteDevice>(_onDeleteDevice);
    on<ToggleDevice>(_onToggleDevice);
    on<FilterByRoom>(_onFilterByRoom);
  }

  Future<void> _onLoadDevices(
      LoadHomeDevices event,
      Emitter<HomeControlState> emit,
      ) async {
    emit(HomeControlLoading());
    try {
      // Здесь должна быть логика загрузки устройств из Supabase
      await Future.delayed(const Duration(seconds: 1));
      emit(HomeControlLoaded(_demoDevices));
    } catch (e) {
      emit(HomeControlError('Failed to load devices: ${e.toString()}'));
    }
  }

  void _onAddDevice(
      AddDevice event,
      Emitter<HomeControlState> emit,
      ) {
    if (state is HomeControlLoaded) {
      final currentState = state as HomeControlLoaded;
      emit(HomeControlLoaded(
        [...currentState.devices, event.device],
        selectedRoom: currentState.selectedRoom,
      ));
    }
  }

  void _onUpdateDevice(
      UpdateDevice event,
      Emitter<HomeControlState> emit,
      ) {
    if (state is HomeControlLoaded) {
      final currentState = state as HomeControlLoaded;
      final updatedDevices = currentState.devices.map((device) {
        return device.id == event.device.id ? event.device : device;
      }).toList();
      emit(currentState.copyWith(devices: updatedDevices));
    }
  }

  void _onDeleteDevice(
      DeleteDevice event,
      Emitter<HomeControlState> emit,
      ) {
    if (state is HomeControlLoaded) {
      final currentState = state as HomeControlLoaded;
      final updatedDevices = currentState.devices
          .where((device) => device.id != event.deviceId)
          .toList();
      emit(currentState.copyWith(devices: updatedDevices));
    }
  }

  void _onToggleDevice(
      ToggleDevice event,
      Emitter<HomeControlState> emit,
      ) {
    if (state is HomeControlLoaded) {
      final currentState = state as HomeControlLoaded;
      final updatedDevices = currentState.devices.map((device) {
        return device.id == event.deviceId
            ? device.copyWith(isOn: !device.isOn)
            : device;
      }).toList();
      emit(currentState.copyWith(devices: updatedDevices));
    }
  }

  void _onFilterByRoom(
      FilterByRoom event,
      Emitter<HomeControlState> emit,
      ) {
    if (state is HomeControlLoaded) {
      final currentState = state as HomeControlLoaded;
      emit(currentState.copyWith(selectedRoom: event.room));
    }
  }

  // Демо-устройства
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