import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testik2/features/scenes/bloc/scenes_event.dart';
import 'package:testik2/features/scenes/bloc/scenes_state.dart';
import 'package:testik2/features/scenes/scenes.dart';

class ScenesBloc extends Bloc<ScenesEvent, ScenesState> {
  ScenesBloc() : super(ScenesLoading()) {
    on<LoadScenes>((event, emit) async {
      emit(ScenesLoading());
      try {
        // Simulate network request
        await Future.delayed(const Duration(seconds: 1));
        emit(ScenesLoaded(_demoScenes));
      } catch (e) {
        emit(ScenesError(e.toString()));
      }
    });

    on<AddNewScene>((event, emit) {
      if (state is ScenesLoaded) {
        final currentState = state as ScenesLoaded;
        final newScene = Scene(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'New Scene ${currentState.scenes.length + 1}',
          isActive: false,
          icon: Icons.lightbulb_outline,
        );
        emit(ScenesLoaded([...currentState.scenes, newScene]));
      }
    });

    on<ToggleScene>((event, emit) {
      if (state is ScenesLoaded) {
        final currentState = state as ScenesLoaded;
        final updatedScenes = currentState.scenes.map((scene) {
          if (scene.id == event.sceneId) {
            return scene.copyWith(isActive: !scene.isActive);
          }
          return scene;
        }).toList();
        emit(ScenesLoaded(updatedScenes));
      }
    });
  }

  final List<Scene> _demoScenes = [
    Scene(id: '1', name: 'Movie Night', isActive: false, icon: Icons.movie),
    Scene(id: '2', name: 'Good Morning', isActive: true, icon: Icons.wb_sunny),
    Scene(id: '3', name: 'Away', isActive: false, icon: Icons.directions_run),
    Scene(id: '4', name: 'Party', isActive: false, icon: Icons.music_note),
  ];
}