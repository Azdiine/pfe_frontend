# 🌍 Guide de Localisation MEATAY

## Vue d'ensemble

MEATAY supporte maintenant **2 langues** avec changement en temps réel:
- 🇫🇷 **Français** (par défaut)
- 🇬🇧 **Anglais**

## Architecture

### 📁 Structure des Fichiers

```
lib/
├── core/
│   └── localization/
│       ├── app_localizations.dart   # Traductions FR/EN
│       └── locale_provider.dart     # Gestion de l'état de la langue
├── shared/
│   └── widgets/
│       └── language_selector.dart   # Widget sélecteur de langue
└── main.dart                        # Configuration globale
```

### 🏗️ Components Principaux

#### 1. **AppLocalizations** (`app_localizations.dart`)
Classe contenant toutes les traductions de l'application.

```dart
final l10n = AppLocalizations.of('fr'); // ou 'en'
print(l10n.welcomeTitle); // "Bienvenue sur MEATAY" ou "Welcome to MEATAY"
```

**Catégories de traductions:**
- 🏠 Welcome & Onboarding
- 👤 Profile
- 🧊 Fridge
- 💬 Chatbot & Notifications
- 🔧 Common (buttons, labels)

#### 2. **LocaleProvider** (`locale_provider.dart`)
Provider Riverpod pour gérer l'état de la langue.

```dart
// Lire la langue actuelle
final locale = ref.watch(localeProvider); // 'fr' ou 'en'

// Changer de langue
ref.read(localeProvider.notifier).toggleLanguage();

// Définir une langue spécifique
ref.read(localeProvider.notifier).setLanguage('en');
```

#### 3. **LanguageSelector** (`language_selector.dart`)
Widget bouton pour changer de langue.

**Deux variantes disponibles:**

##### Standard (avec code langue)
```dart
const LanguageSelector()
```
Affiche: `🇫🇷 FR ⇄` ou `🇬🇧 EN ⇄`

##### Compacte (seulement drapeau)
```dart
const CompactLanguageSelector()
```
Affiche: `🇫🇷` ou `🇬🇧`

## 🚀 Utilisation

### Dans un Widget

1. **Convertir en ConsumerWidget** (si StatelessWidget)
```dart
// Avant
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Bienvenue');
  }
}

// Après
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(locale);
    
    return Text(l10n.welcomeTitle);
  }
}
```

2. **Pour ConsumerStatefulWidget**
```dart
class MyScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(locale);
    
    return Text(l10n.welcomeTitle);
  }
}
```

3. **Dans les méthodes (sans rebuild automatique)**
```dart
void myMethod() {
  final locale = ref.read(localeProvider); // Pas de watch!
  final l10n = AppLocalizations.of(locale);
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.error),
      content: Text(l10n.logoutMessage),
    ),
  );
}
```

### Ajouter de Nouvelles Traductions

1. **Ouvrir** `lib/core/localization/app_localizations.dart`

2. **Ajouter un getter** dans la catégorie appropriée:
```dart
  // 🏠 WELCOME & ONBOARDING
  
  String get myNewString => _translate(
        fr: 'Mon texte en français',
        en: 'My text in English',
      );
```

3. **Utiliser** dans votre widget:
```dart
Text(l10n.myNewString)
```

### Exemples Concrets

#### Boutons
```dart
ElevatedButton(
  onPressed: () {},
  child: Text(l10n.save), // "Enregistrer" / "Save"
)
```

#### Formulaires
```dart
TextField(
  decoration: InputDecoration(
    labelText: l10n.productName, // "Nom du Produit" / "Product Name"
    hintText: l10n.productNameHint, // "ex: Lait..." / "e.g., Milk..."
  ),
)
```

#### Messages d'erreur
```dart
if (error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(l10n.error)),
  );
}
```

#### Navigation
```dart
AppBar(
  title: Text(l10n.profile), // "Profil" / "Profile"
  actions: [
    const LanguageSelector(), // Widget sélecteur
  ],
)
```

## 🔄 Changement de Langue en Temps Réel

Le système reconstruit automatiquement l'application lors du changement de langue:

1. **Utilisateur clique** sur le sélecteur de langue (🇫🇷 → 🇬🇧)
2. **LocaleProvider** change l'état (`'fr'` → `'en'`)
3. **MaterialApp** détecte le changement (via `key: ValueKey(locale)`)
4. **Toute l'app** se reconstruit avec les nouvelles traductions
5. **Feedback haptique** confirme le changement

## 📋 Checklist d'Implémentation

Pour ajouter la localisation à une nouvelle page:

- [ ] Convertir le widget en `ConsumerWidget` ou `ConsumerStatefulWidget`
- [ ] Ajouter `final locale = ref.watch(localeProvider);`
- [ ] Ajouter `final l10n = AppLocalizations.of(locale);`
- [ ] Remplacer tous les strings hardcodés par `l10n.xxx`
- [ ] Vérifier que les nouvelles clés existent dans `app_localizations.dart`
- [ ] Si besoin, ajouter les nouvelles traductions
- [ ] Tester le changement de langue

## 🎨 Personnalisation

### Modifier les Drapeaux
Dans `locale_provider.dart`:
```dart
String get currentLanguageFlag => state == 'fr' ? '🇫🇷' : '🇬🇧';
```

### Changer la Langue par Défaut
Dans `locale_provider.dart`:
```dart
class LocaleNotifier extends StateNotifier<String> {
  LocaleNotifier() : super('en'); // Anglais par défaut
}
```

### Personnaliser le Bouton
Créer votre propre widget:
```dart
class MyCustomSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final notifier = ref.read(localeProvider.notifier);
    
    return TextButton(
      onPressed: notifier.toggleLanguage,
      child: Text(locale == 'fr' ? 'FR' : 'EN'),
    );
  }
}
```

## 📱 Pages Localisées

### ✅ Complètement traduites:
- ✅ Welcome Screen (`welcome_screen.dart`)
- ✅ Profile Screen (`profile_screen.dart`)
- ✅ Shell Navigation (AppBar + BottomNav)

### 🚧 À localiser:
- ⏳ Fridge Page (`frigo_page.dart`)
- ⏳ Recipes Page (`recettes_page.dart`)
- ⏳ Tracking Page (`suivi_page.dart`)
- ⏳ Home Page (`home_page.dart`)
- ⏳ Chatbot Widget (`chatbot_popup.dart`)
- ⏳ Notifications Widget (`notifications_popup.dart`)

## 🐛 Dépannage

### Le texte ne change pas
- Vérifier que vous utilisez `ref.watch()` et non `ref.read()`
- Vérifier que le widget est bien un `ConsumerWidget`

### Erreur "Undefined name 'localeProvider'"
- Ajouter l'import: `import 'package:votre_app/core/localization/locale_provider.dart';`

### La clé de traduction n'existe pas
- Ajouter la traduction dans `app_localizations.dart`
- Formater le fichier avec `dart format`

## 📚 Ressources

- **Riverpod State Management**: https://riverpod.dev
- **Flutter Localization**: https://docs.flutter.dev/ui/accessibility-and-localization/internationalization

---

**Version:** 1.0.0  
**Dernière mise à jour:** Février 2026  
**Contact:** Équipe MEATAY
