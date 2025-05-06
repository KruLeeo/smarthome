

import 'package:testik2/features/scenes/scenes.dart';

abstract class ScenesState {}

class ScenesLoading extends ScenesState {}

class ScenesLoaded extends ScenesState {
  final List<Scene> scenes;

  ScenesLoaded(this.scenes);
}

class ScenesError extends ScenesState {
  final String message;

  ScenesError(this.message);
}