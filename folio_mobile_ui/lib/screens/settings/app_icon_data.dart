import 'package:flutter/material.dart';

class AppIconOption {
  final String id;
  final String name;
  final String category; // 'default', 'colors', 'special'
  final String categoryName;
  final String subtitle;
  final Color backgroundColor;
  final List<Color>? gradientColors;
  final AlignmentGeometry gradientBegin;
  final AlignmentGeometry gradientEnd;
  final Color emblemColor;
  final bool isDefaultImage;
  final bool hasGlow;
  final Color? glowColor;
  final Color? borderColor;
  final double borderWidth;

  const AppIconOption({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryName,
    required this.subtitle,
    this.backgroundColor = const Color(0xFF2563EB),
    this.gradientColors,
    this.gradientBegin = Alignment.topLeft,
    this.gradientEnd = Alignment.bottomRight,
    this.emblemColor = Colors.white,
    this.isDefaultImage = false,
    this.hasGlow = false,
    this.glowColor,
    this.borderColor,
    this.borderWidth = 0.0,
  });
}

class AppIconWidget extends StatelessWidget {
  final AppIconOption option;
  final double size;
  final double borderRadius;
  final bool showShadow;

  const AppIconWidget({
    super.key,
    required this.option,
    this.size = 56.0,
    this.borderRadius = 13.0,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    if (option.isDefaultImage) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 8.0,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.asset(
            'assets/icons/ic_rounded.png',
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    Decoration decoration;
    if (option.gradientColors != null && option.gradientColors!.length >= 2) {
      decoration = BoxDecoration(
        gradient: LinearGradient(
          colors: option.gradientColors!,
          begin: option.gradientBegin,
          end: option.gradientEnd,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: option.borderColor != null
            ? Border.all(
                color: option.borderColor!,
                width: option.borderWidth,
              )
            : null,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: (option.glowColor ?? option.gradientColors!.first)
                      .withValues(alpha: option.hasGlow ? 0.45 : 0.25),
                  blurRadius: option.hasGlow ? 12.0 : 8.0,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      );
    } else {
      decoration = BoxDecoration(
        color: option.backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: option.borderColor != null
            ? Border.all(
                color: option.borderColor!,
                width: option.borderWidth,
              )
            : null,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: (option.glowColor ?? option.backgroundColor)
                      .withValues(alpha: option.hasGlow ? 0.45 : 0.25),
                  blurRadius: option.hasGlow ? 12.0 : 8.0,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: decoration,
      child: Center(
        child: Image.asset(
          'assets/icons/pergamen_emblem.png',
          width: size * 0.65,
          height: size * 0.65,
          fit: BoxFit.contain,
          color: option.emblemColor,
        ),
      ),
    );
  }
}

class AppIconData {
  static const List<AppIconOption> allIcons = [
    // ── Alapértelmezett (Klasszikus) ────────────────────────────────────────
    AppIconOption(
      id: 'default',
      name: 'Pergamen Kék',
      category: 'default',
      categoryName: 'Alapértelmezett',
      subtitle: 'Hivatalos alapértelmezett',
      isDefaultImage: true,
    ),
    AppIconOption(
      id: 'classic_dark',
      name: 'Sötét Elegancia',
      category: 'default',
      categoryName: 'Alapértelmezett',
      subtitle: 'Mélyfekete & Ciánkék',
      backgroundColor: Color(0xFF0F172A),
      emblemColor: Color(0xFF38BDF8),
      hasGlow: true,
      glowColor: Color(0xFF38BDF8),
      borderColor: Color(0x4438BDF8),
      borderWidth: 1.5,
    ),
    AppIconOption(
      id: 'classic_light',
      name: 'Tiszta Fehér',
      category: 'default',
      categoryName: 'Alapértelmezett',
      subtitle: 'Hófehér & Királykék',
      backgroundColor: Color(0xFFF8FAFC),
      emblemColor: Color(0xFF2563EB),
      borderColor: Color(0x33CBD5E1),
      borderWidth: 1.0,
    ),

    // ── Színek (20 különböző árnyalat) ─────────────────────────────────────
    AppIconOption(
      id: 'color_ocean',
      name: 'Óceánkék',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Klasszikus tengerkék',
      backgroundColor: Color(0xFF2563EB),
      emblemColor: Colors.white,
    ),
    AppIconOption(
      id: 'color_emerald',
      name: 'Smaragdzöld',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Élénk erdei zöld',
      backgroundColor: Color(0xFF059669),
      emblemColor: Color(0xFFD1FAE5),
    ),
    AppIconOption(
      id: 'color_mint',
      name: 'Friss Menta',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Hűsítő mentazöld',
      backgroundColor: Color(0xFF10B981),
      emblemColor: Colors.white,
    ),
    AppIconOption(
      id: 'color_ruby',
      name: 'Rubinvörös',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Szenvedélyes vörös',
      backgroundColor: Color(0xFFDC2626),
      emblemColor: Colors.white,
    ),
    AppIconOption(
      id: 'color_crimson',
      name: 'Karmazsin',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Mély nemesvörös',
      backgroundColor: Color(0xFFBE123C),
      emblemColor: Colors.white,
    ),
    AppIconOption(
      id: 'color_coral',
      name: 'Élénk Korall',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Meleg korallrózsaszín',
      backgroundColor: Color(0xFFF43F5E),
      emblemColor: Colors.white,
    ),
    AppIconOption(
      id: 'color_sunset',
      name: 'Naplemente',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Tüzes narancssárga',
      backgroundColor: Color(0xFFEA580C),
      emblemColor: Color(0xFFFEF08A),
    ),
    AppIconOption(
      id: 'color_amber',
      name: 'Borostyán',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Meleg borostyánsárga',
      backgroundColor: Color(0xFFD97706),
      emblemColor: Colors.white,
    ),
    AppIconOption(
      id: 'color_gold',
      name: 'Királyi Arany',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Ragyogó arany',
      backgroundColor: Color(0xFFCA8A04),
      emblemColor: Color(0xFFFEF9C3),
    ),
    AppIconOption(
      id: 'color_amethyst',
      name: 'Ametiszt Lila',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Lila drágakő',
      backgroundColor: Color(0xFF7C3AED),
      emblemColor: Color(0xFFEDE9FE),
    ),
    AppIconOption(
      id: 'color_indigo',
      name: 'Mély Indigó',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Éjféli indigókék',
      backgroundColor: Color(0xFF4338CA),
      emblemColor: Color(0xFFE0E7FF),
    ),
    AppIconOption(
      id: 'color_lavender',
      name: 'Levendula',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Könnyed pasztell lila',
      backgroundColor: Color(0xFF8B5CF6),
      emblemColor: Colors.white,
    ),
    AppIconOption(
      id: 'color_pink',
      name: 'Rózsaszín Álom',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Vidám rágógumi rózsaszín',
      backgroundColor: Color(0xFFDB2777),
      emblemColor: Colors.white,
    ),
    AppIconOption(
      id: 'color_fuchsia',
      name: 'Élénk Fukszia',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Ragyogó bíbor',
      backgroundColor: Color(0xFFC026D3),
      emblemColor: Colors.white,
    ),
    AppIconOption(
      id: 'color_teal',
      name: 'Mély Türkiz',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Mélységi zöldeskék',
      backgroundColor: Color(0xFF0D9488),
      emblemColor: Color(0xFFCCFBF1),
    ),
    AppIconOption(
      id: 'color_cyan',
      name: 'Ciánkék',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Élénk tiszta cián',
      backgroundColor: Color(0xFF0891B2),
      emblemColor: Colors.white,
    ),
    AppIconOption(
      id: 'color_sky',
      name: 'Égszínkék',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Felhőtlen égbolt',
      backgroundColor: Color(0xFF0284C7),
      emblemColor: Colors.white,
    ),
    AppIconOption(
      id: 'color_lime',
      name: 'Neon Lime',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Frissítő zöldcitrom',
      backgroundColor: Color(0xFF65A30D),
      emblemColor: Colors.white,
    ),
    AppIconOption(
      id: 'color_slate',
      name: 'Palaszürke',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Modern grafit ezüst',
      backgroundColor: Color(0xFF334155),
      emblemColor: Color(0xFFF1F5F9),
    ),
    AppIconOption(
      id: 'color_amoled',
      name: 'AMOLED Fekete',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Végtelen fekete & cián',
      backgroundColor: Color(0xFF000000),
      emblemColor: Color(0xFF38BDF8),
      borderColor: Color(0x3338BDF8),
      borderWidth: 1.0,
    ),

    // ── Különleges & Egyedi Gradiens Stílusok ────────────────────────────────
    AppIconOption(
      id: 'special_neon',
      name: 'Neon Ragyogás',
      category: 'special',
      categoryName: 'Egyedi stílusok',
      subtitle: 'Kiber cián aura',
      gradientColors: [Color(0xFF0B1329), Color(0xFF1E1B4B)],
      emblemColor: Color(0xFF38BDF8),
      hasGlow: true,
      glowColor: Color(0xFF38BDF8),
      borderColor: Color(0xFF38BDF8),
      borderWidth: 1.5,
    ),
    AppIconOption(
      id: 'special_cyberpunk',
      name: 'Cyberpunk 2077',
      category: 'special',
      categoryName: 'Egyedi stílusok',
      subtitle: 'Neon sárga & cián',
      gradientColors: [Color(0xFF180828), Color(0xFF2E0854)],
      emblemColor: Color(0xFFFEE715),
      hasGlow: true,
      glowColor: Color(0xFFFEE715),
      borderColor: Color(0xFF00F0FF),
      borderWidth: 1.5,
    ),
    AppIconOption(
      id: 'special_aurora',
      name: 'Sarki Fény',
      category: 'special',
      categoryName: 'Egyedi stílusok',
      subtitle: 'Smaragd-türkiz-kék',
      gradientColors: [Color(0xFF059669), Color(0xFF0284C7), Color(0xFF3B82F6)],
      emblemColor: Colors.white,
      hasGlow: true,
      glowColor: Color(0xFF0284C7),
    ),
    AppIconOption(
      id: 'special_dusk',
      name: 'Alkonyat',
      category: 'special',
      categoryName: 'Egyedi stílusok',
      subtitle: 'Lila-bíbor-narancs naplemente',
      gradientColors: [Color(0xFF581C87), Color(0xFFBE185D), Color(0xFFF97316)],
      emblemColor: Colors.white,
      hasGlow: true,
      glowColor: Color(0xFFBE185D),
    ),
    AppIconOption(
      id: 'special_matrix',
      name: 'Mátrix Kód',
      category: 'special',
      categoryName: 'Egyedi stílusok',
      subtitle: 'Foszforzöld terminál',
      backgroundColor: Color(0xFF000000),
      emblemColor: Color(0xFF22C55E),
      hasGlow: true,
      glowColor: Color(0xFF22C55E),
      borderColor: Color(0xFF22C55E),
      borderWidth: 1.4,
    ),
    AppIconOption(
      id: 'special_retrowave',
      name: 'Retrowave 80s',
      category: 'special',
      categoryName: 'Egyedi stílusok',
      subtitle: 'Neon magenta & mélylila',
      gradientColors: [Color(0xFF1E1B4B), Color(0xFF831843)],
      emblemColor: Color(0xFFF472B6),
      hasGlow: true,
      glowColor: Color(0xFFEC4899),
      borderColor: Color(0xFFF472B6),
      borderWidth: 1.2,
    ),
    AppIconOption(
      id: 'special_frost',
      name: 'Jégkristály',
      category: 'special',
      categoryName: 'Egyedi stílusok',
      subtitle: 'Hűvös téli fagyos kék',
      gradientColors: [Color(0xFF0C4A6E), Color(0xFF0284C7), Color(0xFF38BDF8)],
      emblemColor: Color(0xFFF0F9FF),
      hasGlow: true,
      glowColor: Color(0xFFBAE6FD),
      borderColor: Color(0x66BAE6FD),
      borderWidth: 1.0,
    ),
    AppIconOption(
      id: 'special_royal',
      name: 'Királyi Bársony',
      category: 'special',
      categoryName: 'Egyedi stílusok',
      subtitle: 'Éjkék bársony & nemes arany',
      gradientColors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
      emblemColor: Color(0xFFFBBF24),
      hasGlow: true,
      glowColor: Color(0xFFF59E0B),
      borderColor: Color(0xFFF59E0B),
      borderWidth: 1.5,
    ),
    AppIconOption(
      id: 'special_minimal',
      name: 'Minimalista Vonal',
      category: 'special',
      categoryName: 'Egyedi stílusok',
      subtitle: 'Letisztult kék kontúrvonal',
      backgroundColor: Color(0xFF090D16),
      emblemColor: Colors.white,
      borderColor: Color(0xFF60A5FA),
      borderWidth: 1.5,
    ),
    AppIconOption(
      id: 'special_cosmic',
      name: 'Kozmosz',
      category: 'special',
      categoryName: 'Egyedi stílusok',
      subtitle: 'Mélyűr csillagköd',
      gradientColors: [Color(0xFF030712), Color(0xFF312E81), Color(0xFF4C1D95)],
      emblemColor: Color(0xFFE0E7FF),
      hasGlow: true,
      glowColor: Color(0xFF818CF8),
      borderColor: Color(0x44818CF8),
      borderWidth: 1.0,
    ),
  ];

  static AppIconOption getById(String? id) {
    if (id == null || id.isEmpty || id == 'folio_default') {
      return allIcons.first; // default
    }
    return allIcons.firstWhere(
      (icon) => icon.id == id,
      orElse: () => allIcons.first,
    );
  }
}
