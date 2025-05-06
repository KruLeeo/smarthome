abstract class ScenesEvent {}

class LoadScenes extends ScenesEvent {}

class AddNewScene extends ScenesEvent {}

class ToggleScene extends ScenesEvent {
  final String sceneId;

  ToggleScene(this.sceneId);
}