import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testik2/features/scenes/scenes.dart';

import '../../core/theme/colors.dart';
import 'bloc/scenes_bloc.dart';
import 'bloc/scenes_event.dart';

class SceneCard extends StatelessWidget {
  final Scene scene;

  const SceneCard({super.key, required this.scene});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Palete.darkSurface,
      child: InkWell(
        onTap: () {
          context.read<ScenesBloc>().add(ToggleScene(scene.id));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                scene.icon,
                size: 40,
                color: scene.isActive ? Palete.primary : Palete.lightText,
              ),
              const SizedBox(height: 8),
              Text(
                scene.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: scene.isActive ? Colors.white : Palete.lightText,
                ),
              ),
              const SizedBox(height: 8),
              Switch(
                value: scene.isActive,
                onChanged: (value) {
                  context.read<ScenesBloc>().add(ToggleScene(scene.id));
                },
                activeColor: Palete.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}