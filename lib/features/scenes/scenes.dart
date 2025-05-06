import 'package:flutter/material.dart';

class Scene {
  final String id;
  final String name;
  final bool isActive;
  final IconData icon;

  Scene({
    required this.id,
    required this.name,
    required this.isActive,
    required this.icon,
  });

  Scene copyWith({
    String? id,
    String? name,
    bool? isActive,
    IconData? icon,
  }) {
    return Scene(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      icon: icon ?? this.icon,
    );
  }
}