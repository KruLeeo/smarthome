import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testik2/core/theme/colors.dart';
import 'package:testik2/features/device/device.dart';
import 'home_controll_bloc.dart';

class RoomSelector extends StatelessWidget {
  const RoomSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final unselectedBackground = isDarkTheme ? Palete.darkSurface : Palete.lightSurface;
    final unselectedTextColor = isDarkTheme ? Palete.darkText : Palete.lightText;
    final borderColor = isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade300;

    return BlocBuilder<HomeControlBloc, HomeControlState>(
      builder: (context, state) {
        if (state is! HomeControlLoaded) return const SizedBox();

        final rooms = _getUniqueRooms(state.devices);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(rooms[index]),
                    selected: state.selectedRoom == rooms[index],
                    onSelected: (selected) {
                      context.read<HomeControlBloc>().add(
                        FilterByRoom(selected ? rooms[index] : null),
                      );
                    },
                    backgroundColor: unselectedBackground,
                    selectedColor: Palete.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: state.selectedRoom == rooms[index]
                          ? Colors.white
                          : unselectedTextColor,
                    ),
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: state.selectedRoom == rooms[index]
                            ? Palete.primary
                            : borderColor,
                        width: 1,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<String> _getUniqueRooms(List<Device> devices) {
    final rooms = devices.map((d) => d.room).toSet().toList();
    rooms.insert(0, 'All Rooms');
    return rooms;
  }
}