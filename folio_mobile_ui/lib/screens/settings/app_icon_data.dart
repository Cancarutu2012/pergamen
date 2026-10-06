import 'package:flutter/material.dart';

class AppIconOption {
  final String id;
  final String name;
  final String category; // 'default', 'colors', 'special'
  final String categoryName;
  final String subtitle;

  const AppIconOption({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryName,
    required this.subtitle,
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
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.22),
                  blurRadius: 8.0,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          'assets/icons/app_icons/${option.id}.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/icons/ic_rounded.png',
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
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
      name: 'Pergamen Türkiz',
      category: 'default',
      categoryName: 'Alapértelmezett',
      subtitle: 'Klasszikus türkiz Pergamen ikon eredeti ceruzával',
    ),
    AppIconOption(
      id: 'dark',
      name: 'Sötét Elegancia',
      category: 'default',
      categoryName: 'Alapértelmezett',
      subtitle: 'Modern sötét paletta fehér kontraszttal',
    ),
    AppIconOption(
      id: 'light',
      name: 'Tiszta Fehér',
      category: 'default',
      categoryName: 'Alapértelmezett',
      subtitle: 'Minimalista fehér háttér türkiz ceruzával',
    ),

    // ── Színek ─────────────────────────────────────────────────────────────
    AppIconOption(
      id: 'ocean',
      name: 'Óceánkék',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Mély óceáni kék és jeges árnyalat',
    ),
    AppIconOption(
      id: 'emerald',
      name: 'Smaragd',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Élénk smaragdzöld tiszta kontraszttal',
    ),
    AppIconOption(
      id: 'mint',
      name: 'Friss Menta',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Könnyed pasztell menta zöld',
    ),
    AppIconOption(
      id: 'ruby',
      name: 'Rubin Vörös',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Prémium mély rubinvörös',
    ),
    AppIconOption(
      id: 'coral',
      name: 'Élénk Korall',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Meleg, energikus korall rózsaszín',
    ),
    AppIconOption(
      id: 'sunset',
      name: 'Naplemente',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Meleg narancssárga alkonyati hangulat',
    ),
    AppIconOption(
      id: 'amber',
      name: 'Arany Borostyán',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Gazdag arany és sárga tónus',
    ),
    AppIconOption(
      id: 'purple',
      name: 'Ametiszt',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Elegáns mélylila és ametiszt fény',
    ),
    AppIconOption(
      id: 'indigo',
      name: 'Indigó Kék',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Klasszikus sötétkék és indigó',
    ),
    AppIconOption(
      id: 'pink',
      name: 'Cukorka Rózsaszín',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Vidám és élénk magenta rózsaszín',
    ),
    AppIconOption(
      id: 'cyan',
      name: 'Égkék Cián',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Tiszta égbolt és villanó ciánkék',
    ),
    AppIconOption(
      id: 'amoled',
      name: 'AMOLED Fekete',
      category: 'colors',
      categoryName: 'Színek',
      subtitle: 'Tiszta fekete háttér Pergamen zölddel',
    ),

    // ── Különleges stílusok ────────────────────────────────────────────────
    AppIconOption(
      id: 'cyberpunk',
      name: 'Cyberpunk 2077',
      category: 'special',
      categoryName: 'Különleges',
      subtitle: 'Night City neonsárga és ciánkék stílusa',
    ),
    AppIconOption(
      id: 'matrix',
      name: 'Mátrix',
      category: 'special',
      categoryName: 'Különleges',
      subtitle: 'Digitális eső mélyfekete és foszforzöld',
    ),
    AppIconOption(
      id: 'retrowave',
      name: 'Retrowave',
      category: 'special',
      categoryName: 'Különleges',
      subtitle: '80-as évek szinti neonesztétika',
    ),
    AppIconOption(
      id: 'aurora',
      name: 'Sarki Fény',
      category: 'special',
      categoryName: 'Különleges',
      subtitle: 'Északi égbolt smaragd és türkiz tünemény',
    ),
    AppIconOption(
      id: 'frost',
      name: 'Jégkristály',
      category: 'special',
      categoryName: 'Különleges',
      subtitle: 'Fagyos északi jég és kristálytiszta kék',
    ),
    AppIconOption(
      id: 'royal',
      name: 'Királyi Bársony',
      category: 'special',
      categoryName: 'Különleges',
      subtitle: 'Mély bársonykék ragyogó arany ceruzával',
    ),
  ];

  static AppIconOption getById(String? id) {
    if (id == null || id.isEmpty || id == 'folio_default') {
      return allIcons.first;
    }
    return allIcons.firstWhere(
      (element) => element.id == id,
      orElse: () => allIcons.first,
    );
  }
}
