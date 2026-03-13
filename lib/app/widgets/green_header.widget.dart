import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';

// Dark gradient stops
const _darkHeaderStart = Color(0xFF1A3A1F);
const _darkHeaderEnd   = Color(0xFF0F2413);

// Light gradient stops
const _lightHeaderStart = Color(0xFF388E3C);
const _lightHeaderEnd   = Color(0xFF1B5E20);

// ---------------------------------------------------------------------------
// GreenHeaderAction — standalone icon button (no FHeader ancestor needed).
// ---------------------------------------------------------------------------
class GreenHeaderAction extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPress;

  const GreenHeaderAction({
    super.key,
    required this.icon,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPress,
      child: SizedBox(
        width: 42,
        height: 42,
        child: Center(child: icon),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// GreenHeader — sub-page header (pushed routes), title left-aligned.
// ---------------------------------------------------------------------------
class GreenHeader extends StatelessWidget {
  final String title;
  final List<Widget> suffixes;
  final bool showBack;

  const GreenHeader({
    super.key,
    required this.title,
    this.suffixes = const [],
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topPad = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Container(
        height: kToolbarHeight + topPad,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [_darkHeaderStart, _darkHeaderEnd]
                : [_lightHeaderStart, _lightHeaderEnd],
          ),
        ),
        padding: EdgeInsets.only(top: topPad, left: 4),
        child: IconTheme(
          data: const IconThemeData(color: Colors.white, size: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showBack)
                GreenHeaderAction(
                  icon: const Icon(FIcons.chevronLeft,
                      color: Colors.white, size: 22),
                  onPress: () => Get.back(),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              ...suffixes,
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// greenAppBar — main-tab pages (Scaffold.appBar). Gradient premium.
// ---------------------------------------------------------------------------
PreferredSizeWidget greenAppBar({
  required BuildContext context,
  required String title,
  List<Widget> actions = const [],
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [_darkHeaderStart, _darkHeaderEnd]
                : [_lightHeaderStart, _lightHeaderEnd],
          ),
        ),
        child: IconTheme(
          data: const IconThemeData(color: Colors.white, size: 20),
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white),
            child: FHeader(
              title: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              suffixes: actions,
            ),
          ),
        ),
      ),
    ),
  );
}
