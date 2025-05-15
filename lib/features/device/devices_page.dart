// features/device/devices_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testik2/core/theme/colors.dart';
import 'package:testik2/features/device/bloc/devices_bloc.dart';
import 'package:testik2/features/device/device.dart';
import 'package:testik2/features/device/device_card.dart';
import '../../screens/setting_page.dart';
import 'bloc/devices_event.dart';
import 'bloc/devices_state.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  static Route route() => MaterialPageRoute(builder: (context) => const DevicesPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Devices',
          style: TextStyle(color: Colors.black), // Черный цвет текста
        ),
        backgroundColor: Palete.darkSurface, // Фон остается как был
        iconTheme: IconThemeData(color: Colors.black), // Черные иконки (стрелка назад и др.)
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black), // Явно черная иконка
            onPressed: () => context.read<DevicesBloc>().add(LoadDevicesEvent()),
          ),
        ],
      ),
      backgroundColor: Palete.darkBackground,
      body: const _DeviceList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Palete.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddDeviceDialog(context),
      ),
    );
  }

  static void _showAddDeviceDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String deviceName = '';
    String selectedRoom = 'Living Room';
    DeviceType selectedType = DeviceType.light;

    final rooms = ['Living Room', 'Kitchen', 'Bedroom', 'Bathroom', 'Office'];
    final deviceTypes = DeviceType.values;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Add New Device', style: TextStyle(color: Colors.black)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Device Name',
                      labelStyle: TextStyle(color: Colors.black54),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Palete.primary),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: (value) =>
                    value?.isEmpty ?? true ? 'Name is required' : null,
                    onChanged: (value) => deviceName = value,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedRoom,
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      labelText: 'Room',
                      labelStyle: TextStyle(color: Colors.black54),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Palete.primary),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    items: rooms.map((room) => DropdownMenuItem(
                      value: room,
                      child: Text(room, style: const TextStyle(color: Colors.black)),
                    )).toList(),
                    onChanged: (value) => selectedRoom = value!,
                    validator: (value) =>
                    value == null ? 'Room is required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<DeviceType>(
                    value: selectedType,
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      labelText: 'Device Type',
                      labelStyle: TextStyle(color: Colors.black54),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Palete.primary),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    items: deviceTypes.map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(
                        type.toString().split('.').last,
                        style: const TextStyle(color: Colors.black),
                      ),
                    )).toList(),
                    onChanged: (value) => selectedType = value!,
                    validator: (value) =>
                    value == null ? 'Type is required' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Palete.primary, // Or your light theme primary color
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final newDevice = Device(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: deviceName,
                    type: selectedType,
                    room: selectedRoom,
                  );
                  context.read<DevicesBloc>().add(AddDeviceEvent(newDevice));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class _DeviceList extends StatelessWidget {
  const _DeviceList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesBloc, DevicesState>(
      builder: (context, state) {
        if (state is DevicesLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DevicesErrorState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<DevicesBloc>().add(LoadDevicesEvent()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is DevicesLoadedState) {
          return state.devices.isEmpty
              ? const Center(
            child: Text(
              'No devices found',
              style: TextStyle(color: Palete.lightText),
            ),
          )
              : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.devices.length,
            itemBuilder: (context, index) {
              final device = state.devices[index];
              return DeviceCard(
                device: device,
                onTap: () => context.read<DevicesBloc>().add(ToggleDeviceEvent(device.id)),
                onLongPress: () => _showDeviceOptions(context, device),
              );
            },
          );
        }

        return const Center(child: Text('Unknown state'));
      },
    );
  }

  void _showDeviceOptions(BuildContext context, Device device) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Palete.darkSurface,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.black54),
                title: const Text('Settings', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    DeviceSettingsPage.route(device),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.black54),
                title: const Text('Edit', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  _showEditDeviceDialog(context, device);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, device.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditDeviceDialog(BuildContext context, Device device) {
    final formKey = GlobalKey<FormState>();
    String deviceName = device.name;
    String selectedRoom = device.room;
    DeviceType selectedType = device.type;

    final rooms = ['Living Room', 'Kitchen', 'Bedroom', 'Bathroom', 'Office'];
    final deviceTypes = DeviceType.values;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Palete.darkSurface,
          title: const Text('Edit Device', style: TextStyle(color: Colors.white)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Device Name',
                      labelStyle: TextStyle(color: Palete.lightText),
                    ),
                    style: const TextStyle(color: Colors.white),
                    initialValue: device.name,
                    validator: (value) =>
                    value?.isEmpty ?? true ? 'Name is required' : null,
                    onChanged: (value) => deviceName = value,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedRoom,
                    dropdownColor: Palete.darkSurface,
                    decoration: const InputDecoration(
                      labelText: 'Room',
                      labelStyle: TextStyle(color: Palete.lightText),
                    ),
                    style: const TextStyle(color: Colors.white),
                    items: rooms.map((room) => DropdownMenuItem(
                      value: room,
                      child: Text(room),
                    )).toList(),
                    onChanged: (value) => selectedRoom = value!,
                    validator: (value) =>
                    value == null ? 'Room is required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<DeviceType>(
                    value: selectedType,
                    dropdownColor: Palete.darkSurface,
                    decoration: const InputDecoration(
                      labelText: 'Device Type',
                      labelStyle: TextStyle(color: Palete.lightText),
                    ),
                    style: const TextStyle(color: Colors.white),
                    items: deviceTypes.map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(
                        type.toString().split('.').last,
                        style: const TextStyle(color: Colors.white),
                      ),
                    )).toList(),
                    onChanged: (value) => selectedType = value!,
                    validator: (value) =>
                    value == null ? 'Type is required' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Cancel', style: TextStyle(color: Palete.lightText)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Palete.primary),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final updatedDevice = device.copyWith(
                    name: deviceName,
                    type: selectedType,
                    room: selectedRoom,
                  );
                  context.read<DevicesBloc>().add(UpdateDeviceEvent(updatedDevice));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, String deviceId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Palete.darkSurface,
          title: const Text('Delete Device', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Are you sure you want to delete this device?',
            style: TextStyle(color: Palete.lightText),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Cancel', style: TextStyle(color: Palete.lightText)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                context.read<DevicesBloc>().add(DeleteDeviceEvent(deviceId));
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}