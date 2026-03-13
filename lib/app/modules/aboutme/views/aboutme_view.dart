import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jihati/app/widgets/green_header.widget.dart';

import '../controllers/aboutme_controller.dart';

class AboutmeView extends GetView<AboutmeController> {
  const AboutmeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(top: false,
        child: Column(
          children: [
            GreenHeader(title: 'Tentang Kami'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                child: Column(
                  children: [
                    // ── Hero identity card ─────────────────────────────
                    _HeroCard(isDark: isDark),
                    const SizedBox(height: 24),

                    // ── Body paragraphs ────────────────────────────────
                    ...controller.texts.asMap().entries.map((e) {
                      return _ContentCard(
                        text: e.value,
                        index: e.key,
                        isDark: isDark,
                      );
                    }),

                    const SizedBox(height: 8),

                    // ── Quote card ─────────────────────────────────────
                    _QuoteCard(isDark: isDark),
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
// Hero identity card
// ---------------------------------------------------------------------------
class _HeroCard extends StatelessWidget {
  final bool isDark;
  const _HeroCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1A3A1F), const Color(0xFF0F2413)]
              : [const Color(0xFF388E3C), const Color(0xFF1B5E20)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'PW FORMASI RUA Surabaya',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 1,
            width: 60,
            color: Colors.white.withAlpha(80),
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          const Text(
            'Forum Mahasiswa dan Santri\nRaudlatul Ulum Arrahmaniyah',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              height: 1.6,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Content paragraph card
// ---------------------------------------------------------------------------
class _ContentCard extends StatelessWidget {
  final String text;
  final int index;
  final bool isDark;
  const _ContentCard(
      {required this.text, required this.index, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xFF1E2229) : Colors.white;
    final border =
        isDark ? const Color(0xFF2C3040) : const Color(0xFFEEEEEE);
    final body = isDark ? const Color(0xFFBEC5CF) : const Color(0xFF3D3D3D);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 1),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                    color: Colors.black.withAlpha(6),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Index badge — fixed size so it doesn't stretch
          SizedBox(
            width: 26,
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withAlpha(isDark ? 60 : 30),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.7, color: body),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Quote card
// ---------------------------------------------------------------------------
class _QuoteCard extends StatelessWidget {
  final bool isDark;
  const _QuoteCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? const Color(0xFF1A3A1F).withAlpha(160)
        : const Color(0xFFE8F5E9);
    final textColor =
        isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2E7D32).withAlpha(isDark ? 60 : 40),
        ),
      ),
      child: Column(
        children: [
          Text(
            '"',
            style: TextStyle(
              fontSize: 40,
              height: 1,
              color: textColor.withAlpha(120),
              fontFamily: 'Georgia',
            ),
          ),
          Text(
            'Bersama kita mengaji, menjalani, dan mengabdi.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              height: 1.6,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
