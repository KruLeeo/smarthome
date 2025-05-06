import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testik2/core/theme/colors.dart';
import 'package:testik2/features/device/device.dart';
import 'home_controll_bloc.dart';

class RoomSelector extends StatelessWidget {
  const RoomSelector({super.key});

  @override
  Widget build(BuildContext context) {
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
                    selectedColor: Palete.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: state.selectedRoom == rooms[index]
                          ? Colors.white
                          : Palete.lightText,
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