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
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkTheme ? Palete.darkBackground : Palete.lightBackground;
    final surfaceColor = isDarkTheme ? Palete.darkSurface : Palete.lightSurface;
    final textColor = isDarkTheme ? Palete.darkText : Palete.lightText;
    final iconColor = isDarkTheme ? Palete.darkText : Palete.lightText;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Devices',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: surfaceColor,
        iconTheme: IconThemeData(color: iconColor),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: iconColor),
            onPressed: () => context.read<DevicesBloc>().add(LoadDevicesEvent()),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: const _DeviceList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Palete.primary,
        child: Icon(Icons.add, color: isDarkTheme ? Palete.darkText : Colors.white),
        onPressed: () => _showAddDeviceDialog(context),
      ),
    );
  }

  static void _showAddDeviceDialog(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
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
          backgroundColor: isDarkTheme ? Palete.darkSurface : Palete.lightSurface,
          title: Text(
              'Add New Device',
              style: TextStyle(color: isDarkTheme ? Palete.darkText : Palete.lightText)
          ),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Device Name',
                      labelStyle: TextStyle(
                          color: isDarkTheme ? Palete.darkText.withOpacity(0.7) : Palete.lightText.withOpacity(0.7)
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: isDarkTheme ? Colors.white24 : Colors.black12
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Palete.primary),
                      ),
                    ),
                    style: TextStyle(color: isDarkTheme ? Palete.darkText : Palete.lightText),
                    validator: (value) =>
                    value?.isEmpty ?? true ? 'Name is required' : null,
                    onChanged: (value) => deviceName = value,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedRoom,
                    dropdownColor: isDarkTheme ? Palete.darkSurface : Palete.lightSurface,
                    decoration: InputDecoration(
                      labelText: 'Room',
                      labelStyle: TextStyle(
                          color: isDarkTheme ? Palete.darkText.withOpacity(0.7) : Palete.lightText.withOpacity(0.7)
                      ),
                    ),
                    style: TextStyle(color: isDarkTheme ? Palete.darkText : Palete.lightText),
                    items: rooms.map((room) => DropdownMenuItem(
                      value: room,
                      child: Text(
                          room,
                          style: TextStyle(color: isDarkTheme ? Palete.darkText : Palete.lightText)
                      ),
                    )).toList(),
                    onChanged: (value) => selectedRoom = value!,
                    validator: (value) =>
                    value == null ? 'Room is required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<DeviceType>(
                    value: selectedType,
                    dropdownColor: isDarkTheme ? Palete.darkSurface : Palete.lightSurface,
                    decoration: InputDecoration(
                      labelText: 'Device Type',
                      labelStyle: TextStyle(
                          color: isDarkTheme ? Palete.darkText.withOpacity(0.7) : Palete.lightText.withOpacity(0.7)
                      ),
                    ),
                    style: TextStyle(color: isDarkTheme ? Palete.darkText : Palete.lightText),
                    items: deviceTypes.map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(
                        type.toString().split('.').last,
                        style: TextStyle(color: isDarkTheme ? Palete.darkText : Palete.lightText),
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
              child: Text(
                  'Cancel',
                  style: TextStyle(color: isDarkTheme ? Palete.darkText.withOpacity(0.7) : Palete.lightText.withOpacity(0.7))
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Palete.primary,
                foregroundColor: isDarkTheme ? Palete.darkText : Colors.white,
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
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkTheme ? Palete.darkText : Palete.lightText;

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
                Text(state.message, style: TextStyle(color: textColor)),
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
              ? Center(
            child: Text(
              'No devices found',
              style: TextStyle(color: textColor.withOpacity(0.7)),
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

        return Center(child: Text('Unknown state', style: TextStyle(color: textColor)));
      },
    );
  }

  void _showDeviceOptions(BuildContext context, Device device) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkTheme ? Palete.darkText : Palete.lightText;
    final surfaceColor = isDarkTheme ? Palete.darkSurface : Palete.lightSurface;

    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceColor,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.settings, color: textColor.withOpacity(0.7)),
                title: Text('Settings', style: TextStyle(color: textColor)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    DeviceSettingsPage.route(device),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.edit, color: textColor.withOpacity(0.7)),
                title: Text('Edit', style: TextStyle(color: textColor)),
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
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
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
          backgroundColor: isDarkTheme ? Palete.darkSurface : Palete.lightSurface,
          title: Text(
              'Edit Device',
              style: TextStyle(color: isDarkTheme ? Palete.darkText : Palete.lightText)
          ),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Device Name',
                      labelStyle: TextStyle(
                          color: isDarkTheme ? Palete.darkText.withOpacity(0.7) : Palete.lightText.withOpacity(0.7)
                      ),
                    ),
                    style: TextStyle(color: isDarkTheme ? Palete.darkText : Palete.lightText),
                    initialValue: device.name,
                    validator: (value) =>
                    value?.isEmpty ?? true ? 'Name is required' : null,
                    onChanged: (value) => deviceName = value,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedRoom,
                    dropdownColor: isDarkTheme ? Palete.darkSurface : Palete.lightSurface,
                    decoration: InputDecoration(
                      labelText: 'Room',
                      labelStyle: TextStyle(
                          color: isDarkTheme ? Palete.darkText.withOpacity(0.7) : Palete.lightText.withOpacity(0.7)
                      ),
                    ),
                    style: TextStyle(color: isDarkTheme ? Palete.darkText : Palete.lightText),
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
                    dropdownColor: isDarkTheme ? Palete.darkSurface : Palete.lightSurface,
                    decoration: InputDecoration(
                      labelText: 'Device Type',
                      labelStyle: TextStyle(
                          color: isDarkTheme ? Palete.darkText.withOpacity(0.7) : Palete.lightText.withOpacity(0.7)
                      ),
                    ),
                    style: TextStyle(color: isDarkTheme ? Palete.darkText : Palete.lightText),
                    items: deviceTypes.map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(
                        type.toString().split('.').last,
                        style: TextStyle(color: isDarkTheme ? Palete.darkText : Palete.lightText),
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
              child: Text(
                  'Cancel',
                  style: TextStyle(color: isDarkTheme ? Palete.darkText.withOpacity(0.7) : Palete.lightText.withOpacity(0.7))
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Palete.primary,
                foregroundColor: isDarkTheme ? Palete.darkText : Colors.white,
              ),
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
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkTheme ? Palete.darkText : Palete.lightText;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkTheme ? Palete.darkSurface : Palete.lightSurface,
          title: Text(
              'Delete Device',
              style: TextStyle(color: textColor)
          ),
          content: Text(
            'Are you sure you want to delete this device?',
            style: TextStyle(color: textColor.withOpacity(0.7)),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text(
                  'Cancel',
                  style: TextStyle(color: textColor.withOpacity(0.7))
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                context.read<DevicesBloc>().add(DeleteDeviceEvent(deviceId));
                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}