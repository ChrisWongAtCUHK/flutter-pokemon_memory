import 'package:flutter/material.dart';

import '../models/character_info.dart';

class MemoryTheme {
  const MemoryTheme({
    required this.id,
    required this.name,
    required this.tagline,
    required this.menuIcon,
    required this.cardBackIcon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.catalog,
    required this.winMessage,
  });

  final String id;
  final String name;
  final String tagline;
  final IconData menuIcon;
  final IconData cardBackIcon;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final List<CharacterInfo> catalog;
  final String winMessage;
}
