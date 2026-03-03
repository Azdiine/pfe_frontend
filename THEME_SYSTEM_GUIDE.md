# Guide du Système de Thèmes 🌙☀️

## Vue d'ensemble

Le système de dark/light mode a été implémenté avec succès dans l'application. Les utilisateurs peuvent basculer entre le mode clair et le mode sombre avec un bouton lune/soleil.

## Fichiers créés/modifiés

### ✅ Nouveaux fichiers

1. **`lib/core/providers/theme_provider.dart`**
   - Provider Riverpod pour gérer l'état du thème
   - Sauvegarde automatique de la préférence utilisateur dans SharedPreferences
   - Méthodes : `toggleTheme()`, `setThemeMode(ThemeMode)`

2. **`lib/shared/widgets/theme_switcher.dart`**
   - Widget réutilisable pour basculer entre les thèmes
   - 3 styles disponibles : `iconButton`, `toggle`, `button`
   - Animations fluides entre les modes

### 🔄 Fichiers modifiés

1. **`lib/app/theme.dart`**
   - Dark theme complet avec palette de couleurs cohérente
   - Tous les widgets Material styled pour les deux modes

2. **`lib/main.dart`**
   - Intégration du `themeModeProvider`
   - Configuration des thèmes light et dark

3. **`lib/features/welcome/presentation/screens/welcome_screen.dart`**
   - Bouton de basculement du thème en haut à gauche
   - Toutes les couleurs sont maintenant adaptatives au thème
   - Support complet du dark mode

## Utilisation

### Bouton de basculement du thème

Le widget `ThemeSwitcher` est disponible en 3 styles :

```dart
// Style 1: Bouton icône (par défaut)
ThemeSwitcher(
  style: ThemeSwitcherStyle.iconButton,
)

// Style 2: Toggle switch
ThemeSwitcher(
  style: ThemeSwitcherStyle.toggle,
)

// Style 3: Bouton complet avec texte
ThemeSwitcher(
  style: ThemeSwitcherStyle.button,
)
```

### Accéder au thème dans votre code

```dart
// Dans un ConsumerWidget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    
    // Ou utiliser Theme.of(context)
    final brightness = Theme.of(context).brightness;
    
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Text(
        'Hello',
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
    );
  }
}
```

### Basculer le thème programmatiquement

```dart
// Toggle entre light et dark
ref.read(themeModeProvider.notifier).toggleTheme();

// Définir un thème spécifique
ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system);
```

## Palette de couleurs

### Mode Clair
- Background: `#FFFFFF` (Blanc pur)
- Surface: `#F6F6F6` (Gris clair)
- Primary: `#000000` (Noir)
- Text: `#111111` (Noir profond)
- Secondary Text: `#7A7A7A` (Gris)
- Border: `#EAEAEA`

### Mode Sombre
- Background: `#0A0A0A` (Noir profond)
- Surface: `#1A1A1A` (Gris foncé)
- Card: `#1E1E1E`
- Primary: `#FFFFFF` (Blanc)
- Text: `#E5E5E5` (Gris clair)
- Secondary Text: `#9A9A9A` (Gris atténué)
- Border: `#2A2A2A`

## Bonnes pratiques

1. **Toujours utiliser les couleurs du thème** :
   ```dart
   // ✅ Bon
   color: Theme.of(context).textTheme.bodyLarge?.color
   
   // ❌ Mauvais
   color: Color(0xFF111111)
   ```

2. **Adapter les couleurs selon le thème** :
   ```dart
   final isDark = Theme.of(context).brightness == Brightness.dark;
   color: isDark ? Colors.white : Colors.black
   ```

3. **Utiliser les widgets Material** qui supportent automatiquement les thèmes :
   - `ElevatedButton`
   - `OutlinedButton`
   - `Card`
   - `AppBar`
   - etc.

## Ajouter le bouton à d'autres pages

Pour ajouter le bouton de basculement du thème sur d'autres pages :

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/theme_switcher.dart';

class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Screen'),
        actions: [
          // Ajouter le bouton dans l'AppBar
          ThemeSwitcher(
            style: ThemeSwitcherStyle.iconButton,
          ),
        ],
      ),
      body: // ... votre contenu
    );
  }
}
```

## Persistance

La préférence de thème de l'utilisateur est automatiquement sauvegardée dans `SharedPreferences` et restaurée au redémarrage de l'application.

## Tests

Vous pouvez tester le basculement du thème :
1. Lancer l'application
2. Cliquer sur le bouton lune/soleil en haut à gauche de l'écran Welcome
3. Observer le changement de thème instantané
4. Redémarrer l'application - le thème choisi est conservé

---

**Développé avec ❤️ pour SmartNutri**
