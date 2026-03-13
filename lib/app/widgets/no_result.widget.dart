import 'dart:math' as math;
import 'package:flutter/material.dart';

class NoResultWidget extends StatefulWidget {
  final String text;

  /// Optional custom icon. Defaults to a context-aware icon inferred from [text].
  final IconData? icon;

  const NoResultWidget({super.key, required this.text, this.icon});

  @override
  State<NoResultWidget> createState() => _NoResultWidgetState();
}

class _NoResultWidgetState extends State<NoResultWidget>
    with TickerProviderStateMixin {
  late final AnimationController _floatController;
  late final AnimationController _fadeController;
  late final Animation<double> _floatAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    // Slow float up/down
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Fade + scale in on mount
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..forward();

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _scaleAnim = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  IconData _resolveIcon() {
    if (widget.icon != null) return widget.icon!;
    final t = widget.text.toLowerCase();
    if (t.contains('bookmark') || t.contains('simpan')) {
      return Icons.bookmark_border_rounded;
    }
    if (t.contains('riwayat') || t.contains('history') || t.contains('quran')) {
      return Icons.history_rounded;
    }
    return Icons.inbox_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = const Color(0xFF2E7D32);
    final captionColor = isDark ? const Color(0xFF6B7280) : const Color(0xFFAAAAAA);
    final ringColor = isDark
        ? const Color(0xFF1A3A1F).withAlpha(120)
        : const Color(0xFFE8F5E9);

    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Floating animated icon with decorative rings
              AnimatedBuilder(
                animation: _floatController,
                builder: (_, child) => Transform.translate(
                  offset: Offset(0, _floatAnim.value),
                  child: child,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer ring
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ringColor.withAlpha(60),
                      ),
                    ),
                    // Middle ring
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ringColor,
                      ),
                    ),
                    // Inner icon circle
                    Container(
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? const Color(0xFF1A3A1F)
                            : const Color(0xFFDCEDDB),
                        boxShadow: [
                          BoxShadow(
                            color: iconColor.withAlpha(40),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        _resolveIcon(),
                        size: 30,
                        color: iconColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Title
              Text(
                'Belum Ada Data',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? const Color(0xFFDDE2EA)
                      : const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: captionColor,
                  ),
                ),
              ),

              // Decorative dots
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  return AnimatedBuilder(
                    animation: _floatController,
                    builder: (_, _) {
                      final phase = (i * math.pi * 2 / 3);
                      final val = (math.sin(
                                  _floatController.value * math.pi * 2 + phase) +
                              1) /
                          2;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: iconColor.withAlpha(
                              (80 + (val * 140)).round()),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
