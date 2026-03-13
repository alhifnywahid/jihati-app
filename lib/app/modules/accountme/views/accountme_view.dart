import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'package:jihati/app/widgets/green_header.widget.dart';

import '../controllers/accountme_controller.dart';

class AccountmeView extends GetView<AccountmeController> {
  const AccountmeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(top: false,
        child: Column(
          children: [
            GreenHeader(title: 'Media Sosial'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header section ─────────────────────────────────
                    _SectionHeader(isDark: isDark),
                    const SizedBox(height: 20),

                    // ── Social cards ────────────────────────────────────
                    ...controller.socialMediaData.map((platform) {
                      return _SocialCard(
                        platform: platform,
                        isDark: isDark,
                        controller: controller,
                        context: context,
                      );
                    }),

                    const SizedBox(height: 8),

                    // ── Footer ──────────────────────────────────────────
                    _FooterNote(isDark: isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header with gradient text‐like feel
// ---------------------------------------------------------------------------
class _SectionHeader extends StatelessWidget {
  final bool isDark;
  const _SectionHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Ikuti Kami',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Text(
            'Dapatkan informasi terbaru dan konten menarik dari kami',
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark
                  ? const Color(0xFF8B9099)
                  : const Color(0xFF757575),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Premium social card with press animation
// ---------------------------------------------------------------------------
class _SocialCard extends StatefulWidget {
  final SocialMediaPlatform platform;
  final bool isDark;
  final AccountmeController controller;
  final BuildContext context;

  const _SocialCard({
    required this.platform,
    required this.isDark,
    required this.controller,
    required this.context,
  });

  @override
  State<_SocialCard> createState() => _SocialCardState();
}

class _SocialCardState extends State<_SocialCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final p = widget.platform;
    final iconColor = widget.controller.getPlatformColor(p.platform);
    final cardBg = isDark ? const Color(0xFF1E2229) : Colors.white;
    final pressedBg =
        isDark ? const Color(0xFF242B35) : const Color(0xFFF5F5F5);
    final border =
        isDark ? const Color(0xFF2C3040) : const Color(0xFFEEEEEE);
    final titleColor =
        isDark ? const Color(0xFFDDE2EA) : const Color(0xFF1A1A1A);
    final subColor =
        isDark ? const Color(0xFF8B9099) : const Color(0xFF757575);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.controller.launchUrlWithFeedback(p.url, widget.context);
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: _pressed ? pressedBg : cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: 1),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Platform icon container
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(isDark ? 30 : 20),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  widget.controller.getPlatformIcon(p.platform),
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.platform,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '@${p.username}',
                      style: TextStyle(fontSize: 12, color: subColor),
                    ),
                  ],
                ),
              ),

              // Arrow chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(isDark ? 30 : 20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Buka',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(LucideIcons.external_link, size: 11, color: iconColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Footer note
// ---------------------------------------------------------------------------
class _FooterNote extends StatelessWidget {
  final bool isDark;
  const _FooterNote({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color =
        isDark ? const Color(0xFF4A5568) : const Color(0xFFBDBDBD);
    return Center(
      child: Text(
        'Tap kartu untuk membuka halaman media sosial kami',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, color: color),
      ),
    );
  }
}
