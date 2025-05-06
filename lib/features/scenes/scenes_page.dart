import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testik2/features/scenes/scenes_card.dart';

import '../../core/theme/colors.dart';
import 'bloc/scenes_bloc.dart';
import 'bloc/scenes_event.dart';
import 'bloc/scenes_state.dart';

class ScenesPage extends StatelessWidget {
  const ScenesPage({super.key});

  static route() => MaterialPageRoute(builder: (context) => const ScenesPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scenes'),
        backgroundColor: Palete.darkSurface,
      ),
      backgroundColor: Palete.darkBackground,
      body: BlocBuilder<ScenesBloc, ScenesState>(
        builder: (context, state) {
          if (state is ScenesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ScenesLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: state.scenes.length,
              itemBuilder: (context, index) {
                return SceneCard(scene: state.scenes[index]);
              },
            );
          }

          return const Center(child: Text('Error loading scenes'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ScenesBloc>().add(AddNewScene());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}