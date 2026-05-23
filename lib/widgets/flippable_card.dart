import 'package:flutter/material.dart';

import '../models/memory_card.dart';
import '../themes/memory_theme.dart';
import 'cached_character_sprite.dart';

class FlippableCard extends StatefulWidget {
  const FlippableCard({
    super.key,
    required this.card,
    required this.theme,
    required this.onTap,
    this.enabled = true,
  });

  final MemoryCard card;
  final MemoryTheme theme;
  final VoidCallback onTap;
  final bool enabled;

  @override
  State<FlippableCard> createState() => _FlippableCardState();
}

class _FlippableCardState extends State<FlippableCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _rotation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.card.isFaceUp || widget.card.isMatched) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(FlippableCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final faceUp = widget.card.isFaceUp || widget.card.isMatched;
    if (faceUp && _controller.value < 1) {
      _controller.forward();
    } else if (!faceUp && _controller.value > 0) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enabled ? widget.onTap : null,
      child: AnimatedBuilder(
        animation: _rotation,
        builder: (context, child) {
          final angle = _rotation.value * 3.1415926535;
          final showFront = angle >= 1.5707963267;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: showFront
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(3.1415926535),
                    child: child,
                  )
                : _CardBack(theme: widget.theme),
          );
        },
        child: _CardFront(card: widget.card, theme: widget.theme),
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack({required this.theme});

  final MemoryTheme theme;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.secondaryColor, theme.secondaryColor.withValues(alpha: 0.85)],
        ),
        border: Border.all(color: theme.accentColor, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Icon(theme.cardBackIcon, color: theme.accentColor, size: 36),
      ),
    );
  }
}

class _CardFront extends StatelessWidget {
  const _CardFront({required this.card, required this.theme});

  final MemoryCard card;
  final MemoryTheme theme;

  @override
  Widget build(BuildContext context) {
    final matched = card.isMatched;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: matched ? const Color(0xFFE8F5E9) : Colors.white,
        border: Border.all(
          color: matched ? const Color(0xFF43A047) : theme.primaryColor,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: CachedCharacterSprite(
                  character: card.character,
                  theme: theme,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              color: theme.primaryColor,
              child: Text(
                card.character.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
